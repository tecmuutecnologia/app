# Correção do download de animais no login do produtor — Plano de Implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recomendado) ou superpowers:executing-plans para executar tarefa a tarefa. Os passos usam checkbox (`- [ ]`).

**Goal:** Fazer o download completo baixar os animais de quem entra como produtor, e nunca mais falhar em silêncio quando não baixar.

**Architecture:** Hoje o papel da conta é decidido DUAS vezes por critérios diferentes: no login (`OfflineFirstSyncGateway.resolverPapel`, que dá preferência à propriedade) e de novo dentro do download (`performFullDownload`, que decide só por "existe documento de técnico com `uidPerson == authUid`?"). A correção elimina a segunda decisão: o papel resolvido no login passa a ser insumo do download. Em paralelo, a etapa de animais deixa de engolir erros e de terminar "com sucesso" tendo falhado.

**Tech Stack:** Flutter/Dart, Firestore (`cloud_firestore`), ObjectBox, Riverpod, `flutter_test`. O projeto **não usa mockito nem fake_cloud_firestore** — testes são de funções puras + dublês escritos à mão (ver `test/core/alvos_animais_produtor_test.dart` e `test/features/sincronizacao/sync_page_controller_test.dart`).

**Spec:** este documento (a investigação está na seção "Estado da investigação").

## Global Constraints

- Branch de trabalho: `fix/sync-animais-produtor`.
- Rodar testes com `flutter test` (o projeto todo) ou `flutter test <caminho>` (arquivo).
- Comentários e nomes em português, como o resto do módulo de sincronização.
- Comentário explica **por que**, não o que — padrão já estabelecido nos arquivos de `lib/core/sync/`.
- Nenhuma dependência nova no `pubspec.yaml`.
- Firestore não pode ser instanciado em teste: toda lógica nova precisa nascer como função pura em `lib/core/sync/` para ser testável.

---

## Resultado (19/08/2026)

**Causa raiz confirmada:** existe `tecnico/OYr7yRw1ubDYVQDOSQK2` com
`uidPerson = KrIqahVRAzTfyMSux0rb3SowjSk1` — um técnico fantasma na conta do
produtor, com esse campo e mais nada. `_downloadTecnico` o encontrava, o
download inteiro passava a apontar para ele e trazia zero propriedades e zero
animais, sem erro nenhum na tela.

Evidência: cópia do `data.mdb` do emulador (`app_flutter/tecmuu_objectbox/`),
que continha o `PersonEntity` do produtor e um registro com exatamente
`uidPerson` + `firestoreId`, e nenhuma ocorrência de `tecnico/`,
`propriedades/` ou `animaisProdutores`. Confirmado no console do Firestore.

**Status das tarefas:**

| Tarefa | Status |
|---|---|
| 1 — Instrumentação | dispensada: a evidência veio do `data.mdb` e do log existente |
| 2 — Papel do login decide a fonte | **feita** (`fonteDeDownload`) |
| 3 — Etapa de animais falha visivelmente | **feita** (`erroFatalDaEtapaAnimais`) |
| 4 — Unificar `uidPerson` | **feita** (`chavesUidPerson`) |
| 5 — Dono do cache | descartada: o download rodava, R1 não se confirmou |
| 6 — Validação no aparelho | produtor **validado**; regressão do técnico **pendente** |

Validação do produtor (emulador, 21:23): `🏡 1 propriedade(s)` →
`↳ tecnico/eGxgvzJRlPsJ7hW4Fj1f/propriedades/yRyMrmg5rsezXulSH9eG: 26 animal(is)`
→ `🐄 26`, `📋 24 ações`, `📝 10 visitas`. O `data.mdb` foi de 127 KB para 184 KB.

**Pendente:** apagar `tecnico/OYr7yRw1ubDYVQDOSQK2` e varrer outros fantasmas;
testar o login do técnico (`lucas.tomasini@hotmail.com`) contra regressão.

---

## Estado da investigação

Descartado com evidência do console do Firestore (verificado pelo usuário em 19/08/2026, conta `teste100@gmail.com` / uid `KrIqahVRAzTfyMSux0rb3SowjSk1`, técnico `tecnico/eGxgvzJRlPsJ7hW4Fj1f`):

| Hipótese | Status | Evidência |
|---|---|---|
| Técnico fantasma (`tecnico` com `uidPerson == KrIqah...`) | **descartada** | filtro no console não retorna nada |
| `uidTecnicoPropriedade` gravado como string | **descartada** | é `reference` em todos os registros |
| Apontamentos errados (propriedade ↔ person ↔ animal) | **descartada** | conferidos, corretos |
| Etapa `animais` rodando antes de `propriedades` | **descartada** | `lib/core/sync/sync_etapa.dart:2-11` — `propriedades` (4) vem antes de `animais` (5) |
| Falta de índice para a query do produtor | **descartada** | `firebase/firestore.indexes.json:4-19` (animaisProdutores) e `:486-494` (collection group de `uidPersonProdutor`) |
| Regras do Firestore bloqueando | **descartada** | `firebase/firestore.rules:95-117` — leitura liberada para qualquer autenticado |
| Login do produtor não passa pela sincronização | **descartada** | `lib/features/produtor/presentation/pages/login_produtor_page.dart:277` abre a `SyncPage` |

Sobram apenas causas observáveis em runtime, e é por isso que a Tarefa 1 é instrumentação:

- **R1 — o download completo não roda.** `objectbox_auth_helper.dart:78-83` só baixa se `needsInitialSync() || animalBox.count() == 0`. Numa troca de conta **sem logout** (hot restart, login direto por cima da sessão anterior) `clearUserData` nunca roda, as marcas continuam completas e o cache do usuário anterior continua lá — nada é baixado para o produtor.
- **R2 — a etapa de propriedades traz 0 em runtime.** `alvosAnimaisProdutor` recebe lista vazia e a etapa de animais nem consulta o Firestore (`offline_first_sync_service.dart:704`).
- **R3 — a consulta de animais falha e o erro é engolido.** `offline_first_sync_service.dart:718-731`: qualquer erro que não seja de cota vira um `debugPrint` e a etapa é marcada como concluída com 0 animais.
- **R4 — os animais baixam, mas a lista filtra por outro path.** `animal_repository.dart:61` filtra por `uidTecnicoPropriedadePath` exatamente igual ao path da propriedade aberta.

As Tarefas 2, 3 e 4 valem independentemente de qual delas se confirmar — são defeitos reais que encontrei no caminho. A Tarefa 5 é condicional a R1.

## Estrutura de arquivos

| Arquivo | Responsabilidade |
|---|---|
| `lib/core/sync/fonte_download.dart` (**novo**) | função pura: de onde o download tira os dados (técnico x produtor) |
| `lib/core/sync/resultado_etapa_animais.dart` (**novo**) | função pura: quando a etapa de animais deve falhar em vez de terminar quieta |
| `lib/data/objectbox/offline_first_sync_service.dart` | consome as duas funções; instrumentação |
| `lib/data/objectbox/objectbox_auth_helper.dart` | repassa o papel; instrumentação do guard |
| `lib/features/sincronizacao/domain/sync_gateway.dart` | `baixarTudo` passa a receber a resolução |
| `lib/features/sincronizacao/data/offline_first_sync_gateway.dart` | traduz `PapelResolvido` → `ehProdutor` |
| `lib/features/sincronizacao/presentation/controllers/sync_page_controller.dart` | repassa a resolução que já tinha em mãos |

---

### Tarefa 1: Instrumentação — descobrir qual dos quatro caminhos quebra

Não muda comportamento. É o que separa R1/R2/R3/R4. **Termina com um checkpoint humano:** rodar no aparelho e trazer o log.

**Files:**
- Modify: `lib/data/objectbox/objectbox_auth_helper.dart:78-83`
- Modify: `lib/data/objectbox/offline_first_sync_service.dart:557-605` (`_downloadTodasPropriedades`)
- Modify: `lib/data/objectbox/offline_first_sync_service.dart:686-741` (`_downloadTodosAnimais`)

**Interfaces:**
- Consumes: nada.
- Produces: nada em código. Produz as linhas de log `🔎 login`, `🔎 propriedades`, `🔎 animais`.

- [ ] **Passo 1: logar a decisão do guard de login**

Em `objectbox_auth_helper.dart`, substituir o bloco que hoje começa em `final semAnimaisLocais = ...`:

```dart
    final semAnimaisLocais = ObjectBoxService.instance.animalBox.count() == 0;
    // Diagnóstico do caso "produtor entra e não vê animais": os três números
    // abaixo distinguem "o download nem rodou" de "rodou e trouxe zero".
    debugPrint('🔎 login uid=${user.uid} '
        'needsInitialSync=${syncService.needsInitialSync()} '
        'animaisLocais=${ObjectBoxService.instance.animalBox.count()} '
        'propriedadesLocais=${ObjectBoxService.instance.propriedadeBox.count()}');
    if (syncService.needsInitialSync() || semAnimaisLocais) {
```

- [ ] **Passo 2: logar o ramo e o vínculo na etapa de propriedades**

Em `_downloadTodasPropriedades`, dentro do `if (tecnicoRef != null)`, antes do `docs = ...`:

```dart
      debugPrint('🔎 propriedades: ramo=tecnico path=${tecnicoRef.path}');
```

E no `else`, logo depois de `docs = (await ... ).docs;`:

```dart
      debugPrint('🔎 propriedades: ramo=produtor '
          'person=${personSnapshot.docs.first.id} docs=${docs.length}');
```

- [ ] **Passo 3: logar os alvos e o que cada um baixou**

Em `_downloadTodosAnimais`, no ramo do produtor, depois de `final alvos = alvosAnimaisProdutor(...)`:

```dart
      debugPrint('🔎 animais: ramo=produtor alvos=${alvos.length}');
      for (final alvo in alvos) {
        debugPrint('   ↳ ${alvo.tecnicoPath} | ${alvo.propriedadePath}');
      }
```

E dentro do `for (final entrada in consultas.entries)`, envolvendo a chamada:

```dart
        try {
          final antes = totalAnimais;
          totalAnimais = await _baixarAnimaisPaginado(
            entrada.value,
            entrada.key.tecnicoPath,
            total,
            totalAnimais,
          );
          debugPrint('   ↳ ${entrada.key.propriedadePath}: '
              '${totalAnimais - antes} animal(is)');
        } catch (e) {
```

- [ ] **Passo 4: compilar**

Run: `flutter analyze lib/data/objectbox/objectbox_auth_helper.dart lib/data/objectbox/offline_first_sync_service.dart`
Expected: `No issues found!`

- [ ] **Passo 5: commit**

```bash
git add lib/data/objectbox/objectbox_auth_helper.dart lib/data/objectbox/offline_first_sync_service.dart
git commit -m "diag: instrumenta o download do produtor (guard de login, ramo e alvos)"
```

- [ ] **Passo 6: CHECKPOINT — rodar no aparelho**

```bash
flutter run   # ou o fluxo de hot reload do driver.py, para não apagar o login
adb logcat -c && adb logcat -s flutter | grep -E "🔎|👤|🏡|🐄|⚠️|❌"
```

Fazer **logout pelo botão** e entrar com `teste100@gmail.com`. Leitura do resultado:

| Log | Causa | Vai para |
|---|---|---|
| não aparece `🔎 login`, ou aparece com `needsInitialSync=false animaisLocais>0` | R1 | Tarefa 5 |
| `🔎 propriedades: ramo=tecnico` | papel divergente | Tarefa 2 já resolve |
| `🔎 propriedades: ramo=produtor docs=0` | R2 | investigar person duplicado (`👤 N pessoa(s)` com N>1) |
| `alvos=0` com `🏡 1 propriedade(s)` | `parentPath`/`firestoreId` nulos na box | corrigir gravação da propriedade |
| `alvos=1` e `⚠️ Erro ao baixar animais` | R3 | Tarefa 3 mostra o erro; corrigir a causa que ele apontar |
| `↳ .../propriedades/yRy...: N` com N>0 | R4 | o problema é a tela, não o download |

---

### Tarefa 2: O papel resolvido no login manda no download

**Files:**
- Create: `lib/core/sync/fonte_download.dart`
- Test: `test/core/fonte_download_test.dart`
- Modify: `lib/data/objectbox/offline_first_sync_service.dart:232-258`
- Modify: `lib/data/objectbox/objectbox_auth_helper.dart:62-81`
- Modify: `lib/features/sincronizacao/domain/sync_gateway.dart:23`
- Modify: `lib/features/sincronizacao/data/offline_first_sync_gateway.dart:34-39`
- Modify: `lib/features/sincronizacao/presentation/controllers/sync_page_controller.dart:81`
- Modify: `test/features/sincronizacao/sync_page_controller_test.dart:13-77`

**Interfaces:**
- Consumes: `PapelResolvido` (`lib/features/sincronizacao/domain/decisao_pos_login.dart`).
- Produces:
  - `enum FonteDeDownload { tecnico, produtor }`
  - `FonteDeDownload fonteDeDownload({required bool? ehProdutor, required bool temDocumentoDeTecnico})`
  - `OfflineFirstSyncService.performFullDownload({required String userId, bool? ehProdutor, SyncProgressCallback? onProgress})`
  - `ObjectBoxAuthHelper.onUserLogin(User user, {bool? ehProdutor})`
  - `SyncGateway.baixarTudo(ResolucaoPapel resolucao)`

- [ ] **Passo 1: escrever o teste que falha**

Criar `test/core/fonte_download_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/fonte_download.dart';

/// O download decidia sozinho de quem era a sessão, por um critério diferente
/// do usado no login: "existe documento de técnico com este uid?". Um técnico
/// fantasma — criado por um cadastro indevido na conta de um produtor — fazia
/// o download inteiro apontar para um documento vazio, e o produtor entrava
/// sem rebanho. Aqui o papel já resolvido no login vence.
void main() {
  group('fonteDeDownload', () {
    test('produtor declarado ignora o documento de técnico', () {
      expect(
        fonteDeDownload(ehProdutor: true, temDocumentoDeTecnico: true),
        FonteDeDownload.produtor,
      );
    });

    test('técnico declarado com documento baixa pelo técnico', () {
      expect(
        fonteDeDownload(ehProdutor: false, temDocumentoDeTecnico: true),
        FonteDeDownload.tecnico,
      );
    });

    test('técnico declarado sem documento cai no caminho do produtor', () {
      expect(
        fonteDeDownload(ehProdutor: false, temDocumentoDeTecnico: false),
        FonteDeDownload.produtor,
      );
    });

    test('sem papel informado vale o documento — comportamento antigo', () {
      expect(
        fonteDeDownload(ehProdutor: null, temDocumentoDeTecnico: true),
        FonteDeDownload.tecnico,
      );
      expect(
        fonteDeDownload(ehProdutor: null, temDocumentoDeTecnico: false),
        FonteDeDownload.produtor,
      );
    });
  });
}
```

- [ ] **Passo 2: rodar e ver falhar**

Run: `flutter test test/core/fonte_download_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:tecmuu/core/sync/fonte_download.dart'`

- [ ] **Passo 3: implementar a função pura**

Criar `lib/core/sync/fonte_download.dart`:

```dart
/// De onde o download completo tira os dados.
enum FonteDeDownload {
  /// Subcoleções do documento do técnico logado (`tecnico/{id}/...`).
  tecnico,

  /// Pelas propriedades do produtor — ver `alvosAnimaisProdutor`.
  produtor,
}

/// Decide a fonte do download a partir do papel JÁ resolvido no login.
///
/// Existe porque o papel era decidido duas vezes, por critérios diferentes: o
/// login dá preferência à propriedade ligada à pessoa (`decidirPosLogin`), e o
/// download olhava só para "existe documento de técnico com este uid?". Um
/// técnico fantasma na conta de um produtor bastava para o download inteiro
/// apontar para um documento vazio — e o produtor entrava sem rebanho, sem
/// nenhum erro na tela.
///
/// [ehProdutor] nulo = ninguém informou (chamadas que não vêm do login, como
/// `forceFullSync`); aí vale o critério antigo.
FonteDeDownload fonteDeDownload({
  required bool? ehProdutor,
  required bool temDocumentoDeTecnico,
}) {
  if (ehProdutor == true) return FonteDeDownload.produtor;
  return temDocumentoDeTecnico
      ? FonteDeDownload.tecnico
      : FonteDeDownload.produtor;
}
```

- [ ] **Passo 4: rodar e ver passar**

Run: `flutter test test/core/fonte_download_test.dart`
Expected: PASS (5 testes)

- [ ] **Passo 5: consumir a função no serviço de sincronização**

Em `offline_first_sync_service.dart`, adicionar o import:

```dart
import '../../core/sync/fonte_download.dart';
```

Trocar a assinatura de `performFullDownload`:

```dart
  Future<void> performFullDownload({
    required String userId,
    bool? ehProdutor,
    SyncProgressCallback? onProgress,
  }) async {
```

Adicionar o helper privado logo abaixo de `_tecnicoRefLocal()`:

```dart
  /// Descarta o documento de técnico quando o login já resolveu que a conta é
  /// de PRODUTOR: com `tecnicoRef` nulo, as etapas seguintes usam o caminho das
  /// propriedades dele. É o que impede um técnico fantasma de sequestrar o
  /// download inteiro.
  DocumentReference? _refDaFonte(
    DocumentReference? tecnicoRef,
    bool? ehProdutor,
  ) =>
      fonteDeDownload(
                ehProdutor: ehProdutor,
                temDocumentoDeTecnico: tecnicoRef != null,
              ) ==
              FonteDeDownload.produtor
          ? null
          : tecnicoRef;
```

Aplicar nos dois pontos em que `tecnicoRef` é atribuído:

```dart
    DocumentReference? tecnicoRef = _refDaFonte(
      checkpoint.concluidas.contains(SyncEtapa.tecnico)
          ? _tecnicoRefLocal()
          : null,
      ehProdutor,
    );
```

```dart
          case SyncEtapa.tecnico:
            _reportProgress(etapa, 'Dados do técnico');
            tecnicoRef = _refDaFonte(await _downloadTecnico(userId), ehProdutor);
```

- [ ] **Passo 6: propagar pelo helper de autenticação**

Em `objectbox_auth_helper.dart`:

```dart
  static Future<void> onUserLogin(User user, {bool? ehProdutor}) async {
```

```dart
      await syncService.performFullDownload(
        userId: user.uid,
        ehProdutor: ehProdutor,
      );
```

- [ ] **Passo 7: a porta passa a receber a resolução**

Em `sync_gateway.dart`:

```dart
  /// Download completo (ou sincronizacao de pendencias, se ja houver dados).
  /// Recebe a resolucao do login para nao re-decidir o papel por outro
  /// criterio — era essa divergencia que deixava o produtor sem rebanho.
  /// Lanca `SyncOfflineException` ou `SyncFalhaException`.
  Future<void> baixarTudo(ResolucaoPapel resolucao);
```

Em `offline_first_sync_gateway.dart`:

```dart
  @override
  Future<void> baixarTudo(ResolucaoPapel resolucao) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await ObjectBoxAuthHelper.onUserLogin(
      user,
      ehProdutor: resolucao.papel == PapelResolvido.produtor,
    );
  }
```

Em `sync_page_controller.dart`, dentro do `try` interno:

```dart
        await _gateway.baixarTudo(resolucao);
```

- [ ] **Passo 8: teste do controller — a resolução chega ao download**

Em `test/features/sincronizacao/sync_page_controller_test.dart`, ajustar o dublê:

```dart
  /// Resolucao que o controller repassou ao download. O papel resolvido no
  /// login precisa chegar ate aqui: e ele que decide de onde os animais vem.
  ResolucaoPapel? resolucaoRecebidaNoDownload;

  @override
  Future<void> baixarTudo(ResolucaoPapel resolucao) async {
    vezesQueBaixou++;
    resolucaoRecebidaNoDownload = resolucao;
    if (erroAoBaixar != null) throw erroAoBaixar!;
    final gate = baixarTudoGate;
    if (gate != null) await gate.future;
  }
```

E acrescentar o teste no grupo `caminho feliz`:

```dart
    test('repassa ao download o papel resolvido no login', () async {
      final fake = FakeSyncGateway(
        resolucao: const ResolucaoPapel(
          papel: PapelResolvido.produtor,
          conflita: false,
        ),
        destino: const DestinoInicioPropriedadeProdutor(null),
      );
      final container = containerCom(fake);

      await container
          .read(syncPageControllerProvider.notifier)
          .iniciar(SyncPapel.produtor);

      expect(
        fake.resolucaoRecebidaNoDownload?.papel,
        PapelResolvido.produtor,
      );
    });
```

- [ ] **Passo 9: rodar a suíte**

Run: `flutter test`
Expected: PASS em tudo. Se algum outro dublê de `SyncGateway` existir, o compilador aponta — ajustar a assinatura lá também.

- [ ] **Passo 10: commit**

```bash
git add lib/core/sync/fonte_download.dart test/core/fonte_download_test.dart \
  lib/data/objectbox/offline_first_sync_service.dart \
  lib/data/objectbox/objectbox_auth_helper.dart \
  lib/features/sincronizacao lib/features/sincronizacao/presentation \
  test/features/sincronizacao/sync_page_controller_test.dart
git commit -m "fix: papel resolvido no login passa a decidir a fonte do download"
```

---

### Tarefa 3: A etapa de animais deixa de falhar em silêncio

**Files:**
- Create: `lib/core/sync/resultado_etapa_animais.dart`
- Test: `test/core/resultado_etapa_animais_test.dart`
- Modify: `lib/data/objectbox/offline_first_sync_service.dart:702-741`

**Interfaces:**
- Consumes: nada da Tarefa 2 (independente).
- Produces: `Object? erroFatalDaEtapaAnimais({required int alvos, required int falhas, required Object? primeiroErro})`

- [ ] **Passo 1: escrever o teste que falha**

Criar `test/core/resultado_etapa_animais_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/resultado_etapa_animais.dart';

/// A etapa de animais do produtor consulta um alvo por propriedade e engolia
/// qualquer erro que não fosse de cota: a etapa terminava marcada como
/// concluída com zero animais, e a tela dizia "pronto". Falhar em TODOS os
/// alvos não é um contratempo — é a etapa não ter acontecido.
void main() {
  group('erroFatalDaEtapaAnimais', () {
    final erro = Exception('permission-denied');

    test('todos os alvos falharam: a etapa falhou', () {
      expect(
        erroFatalDaEtapaAnimais(alvos: 2, falhas: 2, primeiroErro: erro),
        erro,
      );
    });

    test('falha parcial não derruba a etapa', () {
      expect(
        erroFatalDaEtapaAnimais(alvos: 2, falhas: 1, primeiroErro: erro),
        isNull,
      );
    });

    test('sem alvos não há falha — produtor sem propriedade sincronizada', () {
      expect(
        erroFatalDaEtapaAnimais(alvos: 0, falhas: 0, primeiroErro: null),
        isNull,
      );
    });

    test('rebanho legitimamente vazio não é erro', () {
      expect(
        erroFatalDaEtapaAnimais(alvos: 1, falhas: 0, primeiroErro: null),
        isNull,
      );
    });
  });
}
```

- [ ] **Passo 2: rodar e ver falhar**

Run: `flutter test test/core/resultado_etapa_animais_test.dart`
Expected: FAIL — `Target of URI doesn't exist`

- [ ] **Passo 3: implementar**

Criar `lib/core/sync/resultado_etapa_animais.dart`:

```dart
/// Devolve o erro que deve derrubar a etapa de animais, ou `null` se ela pode
/// ser dada por concluída.
///
/// O laço de alvos do produtor só relançava erro de cota; o resto virava um
/// `debugPrint` e a etapa era marcada como concluída mesmo sem ter baixado
/// nada. Um erro de índice ou de permissão ficava invisível: o produtor entrava
/// num app sem rebanho e sem mensagem alguma.
///
/// Falha parcial (um alvo entre vários) continua tolerada de propósito: os
/// animais das outras propriedades desceram e valem mais do que um login
/// abortado.
Object? erroFatalDaEtapaAnimais({
  required int alvos,
  required int falhas,
  required Object? primeiroErro,
}) =>
    alvos > 0 && falhas == alvos ? primeiroErro : null;
```

- [ ] **Passo 4: rodar e ver passar**

Run: `flutter test test/core/resultado_etapa_animais_test.dart`
Expected: PASS (4 testes)

- [ ] **Passo 5: consumir no serviço**

Import em `offline_first_sync_service.dart`:

```dart
import '../../core/sync/resultado_etapa_animais.dart';
```

No ramo do produtor de `_downloadTodosAnimais`, substituir o laço por:

```dart
      int falhas = 0;
      Object? primeiroErro;

      for (final entrada in consultas.entries) {
        try {
          final antes = totalAnimais;
          totalAnimais = await _baixarAnimaisPaginado(
            entrada.value,
            entrada.key.tecnicoPath,
            total,
            totalAnimais,
          );
          debugPrint('   ↳ ${entrada.key.propriedadePath}: '
              '${totalAnimais - antes} animal(is)');
        } catch (e) {
          falhas++;
          primeiroErro ??= e;
          debugPrint(
              '⚠️ Erro ao baixar animais de ${entrada.key.propriedadePath}: $e');
          // Cota estourada aborta a etapa em vez de ser engolida: se fosse
          // engolida, o laco de checkpoint marcaria a etapa como concluida sem
          // ter baixado nada, e a retomada a pularia para sempre.
          if (ehErroDeCota(e)) rethrow;
        }
      }

      // O `catch` de `performFullDownload` embrulha isto em
      // `SyncFalhaException(etapa)`, e a tela mostra qual etapa quebrou.
      final fatal = erroFatalDaEtapaAnimais(
        alvos: consultas.length,
        falhas: falhas,
        primeiroErro: primeiroErro,
      );
      if (fatal != null) throw fatal;
```

- [ ] **Passo 6: rodar a suíte e o analisador**

Run: `flutter test && flutter analyze lib/data/objectbox/offline_first_sync_service.dart`
Expected: PASS / `No issues found!`

- [ ] **Passo 7: commit**

```bash
git add lib/core/sync/resultado_etapa_animais.dart \
  test/core/resultado_etapa_animais_test.dart \
  lib/data/objectbox/offline_first_sync_service.dart
git commit -m "fix: etapa de animais do produtor falha visivelmente quando todos os alvos erram"
```

---

### Tarefa 4: Unificar a convenção do campo `uidPerson`

Defeito espelho, encontrado durante a investigação: `uidPerson` é gravado de **duas** formas e consultado de **duas** formas.

- Escrita A — `lib/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart:1107`: `uidPerson: personRecord.reference.id` (id do documento).
- Escrita B — `lib/features/propriedades/presentation/pages/lista_propriedade_page.dart:688` e `editar_propriedade_page.dart:1201`: `uidPerson: currentUserUid` (uid do Auth).
- Consulta A — `offline_first_sync_gateway.dart:73`: compara com `person.reference.id`.
- Consulta B — `offline_first_sync_service.dart:469`: compara com o uid do Auth.

Coincidem só porque contas criadas pelo técnico nascem como `person/{uid}` (`produtor_account_service.dart:51-54`). Um técnico cujo `person` tenha id automático fica invisível à Consulta B: `_downloadTecnico` devolve nulo e **o técnico cai no caminho do produtor**.

**Files:**
- Modify: `lib/data/objectbox/offline_first_sync_service.dart:467-471`
- Modify: `lib/features/sincronizacao/data/offline_first_sync_gateway.dart:70-77`
- Modify: `lib/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart:1107`
- Create: `lib/core/sync/chaves_uid_person.dart`
- Test: `test/core/chaves_uid_person_test.dart`

**Interfaces:**
- Produces: `List<String> chavesUidPerson({required String authUid, required String? personDocId})`

- [ ] **Passo 1: escrever o teste que falha**

Criar `test/core/chaves_uid_person_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/chaves_uid_person.dart';

/// `uidPerson` foi gravado ora com o uid do Auth, ora com o id do documento
/// `person`. Enquanto existir documento das duas épocas, a consulta precisa
/// aceitar os dois valores — sem repetir o mesmo valor no `whereIn`, que o
/// Firestore rejeita.
void main() {
  group('chavesUidPerson', () {
    test('valores diferentes viram duas chaves', () {
      expect(
        chavesUidPerson(authUid: 'uid1', personDocId: 'doc1'),
        ['uid1', 'doc1'],
      );
    });

    test('person/{uid} não duplica a chave', () {
      expect(
        chavesUidPerson(authUid: 'uid1', personDocId: 'uid1'),
        ['uid1'],
      );
    });

    test('sem person local resta o uid do Auth', () {
      expect(chavesUidPerson(authUid: 'uid1', personDocId: null), ['uid1']);
    });
  });
}
```

- [ ] **Passo 2: rodar e ver falhar**

Run: `flutter test test/core/chaves_uid_person_test.dart`
Expected: FAIL — `Target of URI doesn't exist`

- [ ] **Passo 3: implementar**

Criar `lib/core/sync/chaves_uid_person.dart`:

```dart
/// Valores aceitáveis para o campo `uidPerson` de um documento de técnico.
///
/// O campo nasceu ambíguo: `completar_perfil_tecnico_page` gravava o id do
/// documento `person`, enquanto as telas de propriedade gravavam o uid do
/// Auth. Coincidem quando o `person` foi criado como `person/{uid}`, e só por
/// isso o descompasso passou despercebido — um técnico com `person` de id
/// automático ficava invisível ao download e era tratado como produtor.
///
/// Ordem estável (Auth primeiro) e sem repetição: `whereIn` rejeita valores
/// duplicados.
List<String> chavesUidPerson({
  required String authUid,
  required String? personDocId,
}) =>
    <String>{authUid, if (personDocId != null) personDocId}.toList();
```

- [ ] **Passo 4: rodar e ver passar**

Run: `flutter test test/core/chaves_uid_person_test.dart`
Expected: PASS (3 testes)

- [ ] **Passo 5: usar na consulta do download**

Em `offline_first_sync_service.dart`, `_downloadTecnico` passa a aceitar os dois valores. O `person` já foi baixado pela etapa anterior (`SyncEtapa.usuario` roda antes de `SyncEtapa.tecnico`), então o id sai da box local — sem ida extra à rede:

```dart
  Future<DocumentReference?> _downloadTecnico(String userId) async {
    final personLocal = _objectBox.personBox
        .query(PersonEntity_.uid.equals(userId))
        .build()
        .findFirst();

    final snapshot = await _firestore
        .collection('tecnico')
        .where('uidPerson',
            whereIn: chavesUidPerson(
              authUid: userId,
              personDocId: personLocal?.firestoreId,
            ))
        .get();
```

Import: `import '../../core/sync/chaves_uid_person.dart';`

- [ ] **Passo 6: usar na consulta do gateway**

Em `offline_first_sync_gateway.dart`:

```dart
    final tecnico = propriedade != null
        ? null
        : await queryTecnicoRecordOnce(
            queryBuilder: (r) => r.where(
              'uidPerson',
              whereIn: chavesUidPerson(
                authUid: currentUserUid,
                personDocId: person.reference.id,
              ),
            ),
            singleRecord: true,
          ).then((s) => s.firstOrNull);
```

Import: `import '/core/sync/chaves_uid_person.dart';`

- [ ] **Passo 7: padronizar a escrita**

Em `completar_perfil_tecnico_page.dart:1107`, trocar `uidPerson: completarPerfilTecnicoPersonRecord.reference.id` por:

```dart
                  uidPerson: currentUserUid,
```

Conferir que `currentUserUid` já está no escopo (o arquivo importa `auth_util.dart`); se não estiver, adicionar `import '/core/auth/firebase_auth/auth_util.dart';`.

- [ ] **Passo 8: rodar a suíte e o analisador**

Run: `flutter test && flutter analyze lib`
Expected: PASS / `No issues found!`

- [ ] **Passo 9: commit**

```bash
git add lib/core/sync/chaves_uid_person.dart test/core/chaves_uid_person_test.dart \
  lib/data/objectbox/offline_first_sync_service.dart \
  lib/features/sincronizacao/data/offline_first_sync_gateway.dart \
  lib/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart
git commit -m "fix: unifica a convencao de uidPerson entre escrita, login e download"
```

---

### Tarefa 5 (CONDICIONAL a R1): o cache passa a saber de quem ele é

Só executar se a Tarefa 1 mostrar `needsInitialSync=false` com `animaisLocais>0` num login de produtor — ou seja, o download foi pulado porque o cache do usuário anterior continuava lá.

`clearUserData` (`objectbox_service.dart:164-175`) zera as marcas e as pendências, mas **não** apaga animais, propriedades e ações do usuário anterior; e nada disso roda quando a sessão troca sem logout.

**Files:**
- Modify: `lib/data/objectbox/objectbox_auth_helper.dart:62-83`
- Create: `lib/core/sync/dono_do_cache.dart`
- Test: `test/core/dono_do_cache_test.dart`

**Interfaces:**
- Produces: `bool cachePrecisaSerDescartado({required String? donoAtual, required String uidLogado})`

- [ ] **Passo 1: escrever o teste que falha**

Criar `test/core/dono_do_cache_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/dono_do_cache.dart';

/// O cache local não guardava de quem ele era. Numa troca de conta sem logout
/// (hot restart, login por cima da sessão anterior), as marcas de "já baixei
/// tudo" continuavam válidas e o rebanho do usuário anterior continuava na
/// box: o novo usuário entrava com dados que não são dele e sem download.
void main() {
  group('cachePrecisaSerDescartado', () {
    test('outro usuário: descarta', () {
      expect(
        cachePrecisaSerDescartado(donoAtual: 'uidA', uidLogado: 'uidB'),
        isTrue,
      );
    });

    test('mesmo usuário: preserva', () {
      expect(
        cachePrecisaSerDescartado(donoAtual: 'uidA', uidLogado: 'uidA'),
        isFalse,
      );
    });

    test('instalação nova (sem dono) preserva — o download completo vem a seguir', () {
      expect(
        cachePrecisaSerDescartado(donoAtual: null, uidLogado: 'uidA'),
        isFalse,
      );
    });
  });
}
```

- [ ] **Passo 2: rodar e ver falhar**

Run: `flutter test test/core/dono_do_cache_test.dart`
Expected: FAIL — `Target of URI doesn't exist`

- [ ] **Passo 3: implementar**

Criar `lib/core/sync/dono_do_cache.dart`:

```dart
/// Chave, em `SharedPreferences`, do uid dono do cache local.
const String kChaveDonoDoCache = 'cache_owner_uid';

/// O cache local pertence a outra conta e precisa ser descartado antes do
/// download.
///
/// Sem dono registrado a resposta é `false` de propósito: instalação nova (ou
/// anterior a esta versão) não tem nada a perder e o download completo que vem
/// logo em seguida preenche tudo.
bool cachePrecisaSerDescartado({
  required String? donoAtual,
  required String uidLogado,
}) =>
    donoAtual != null && donoAtual != uidLogado;
```

- [ ] **Passo 4: rodar e ver passar**

Run: `flutter test test/core/dono_do_cache_test.dart`
Expected: PASS (3 testes)

- [ ] **Passo 5: usar no login**

O dono do cache mora em `SharedPreferences`, não no ObjectBox: `SyncMetadataEntity`
(`lib/data/objectbox/entities/sync_metadata_entity.dart`) não tem campo de texto livre, e
acrescentar um exigiria `build_runner` e migração do modelo por causa de um único valor.
O projeto já guarda estado de migração em prefs (`animal_struct_adapter.dart:198`).

Em `objectbox_auth_helper.dart`, dentro de `onUserLogin`, antes do guard do download:

```dart
    final prefs = await SharedPreferences.getInstance();
    final dono = prefs.getString(kChaveDonoDoCache);

    if (cachePrecisaSerDescartado(donoAtual: dono, uidLogado: user.uid)) {
      debugPrint('🧹 Cache de outra conta ($dono) encontrado — descartando');
      await ObjectBoxService.instance.clearAllData();
    }
    await prefs.setString(kChaveDonoDoCache, user.uid);
```

Imports:

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/sync/dono_do_cache.dart';
```

- [ ] **Passo 6: rodar a suíte**

Run: `flutter test && flutter analyze lib`
Expected: PASS / `No issues found!`

- [ ] **Passo 7: commit**

```bash
git add lib/core/sync/dono_do_cache.dart test/core/dono_do_cache_test.dart \
  lib/data/objectbox/objectbox_auth_helper.dart
git commit -m "fix: cache local registra o dono e e descartado na troca de conta"
```

---

### Tarefa 6: Validação no aparelho

- [ ] **Passo 1: reinstalar limpo e entrar como produtor**

```bash
adb uninstall com.tecmuu.app 2>/dev/null; flutter run
adb logcat -c && adb logcat -s flutter | grep -E "🔎|🏡|🐄|⚠️|❌"
```

Entrar com `teste100@gmail.com`. Esperado: `🔎 propriedades: ramo=produtor docs=1`, `🔎 animais: ramo=produtor alvos=1`, `↳ tecnico/eGxgvzJRlPsJ7hW4Fj1f/propriedades/yRyMrmg5rsezXulSH9eG: N` com N igual à contagem do console do Firestore, e a lista de animais preenchida na tela.

- [ ] **Passo 2: não houve regressão para o técnico**

Logout, entrar com `lucas.tomasini@hotmail.com`. Esperado: `🔎 propriedades: ramo=tecnico`, `🐄 N animal(is)` com N igual ao contador do técnico, e as telas de rebanho iguais a antes.

- [ ] **Passo 3: conferir os dados no ObjectBox Admin**

```bash
./abrir_admin_objectbox.sh
```

Conferir `AnimalEntity` com `uidTecnicoPropriedadePath == tecnico/eGxgvzJRlPsJ7hW4Fj1f/propriedades/yRyMrmg5rsezXulSH9eG`.

- [ ] **Passo 4: remover a instrumentação que não vale manter**

Manter os logs de contagem por alvo (baratos e úteis em suporte); remover os `🔎` de diagnóstico do guard de login se poluírem.

```bash
git add -A && git commit -m "chore: enxuga a instrumentacao de diagnostico do download"
```
