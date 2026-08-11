# Desempenho online e sincronização resiliente — Plano de Implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fazer a sincronização inicial retomar de onde parou em vez de reiniciar do zero, e eliminar o tráfego Firestore desnecessário que deixa o app lento quando online.

**Architecture:** A lógica de decisão sai do `OfflineFirstSyncService` (que é I/O puro e não testável) para unidades puras em `lib/core/sync/`, testadas isoladamente. O `performFullDownload` vira um laço sobre `SyncEtapa` guiado por marcas persistidas em `SyncMetadataEntity`. Os 40 listeners `.snapshots()` dão lugar a três queries delta no ciclo periódico já existente.

**Tech Stack:** Flutter 3.32.8 / Dart 3.8.1, ObjectBox, cloud_firestore, Riverpod, `flutter_test` com dublês escritos à mão.

## Global Constraints

- **Sem mockito.** O projeto usa dublês escritos à mão (ver `test/features/sincronizacao/sync_page_controller_test.dart:13`). Nenhuma tarefa adiciona dependência de mock.
- **Lógica pura em `lib/core/sync/`**, testada em `test/core/sync/`. Nenhum teste abre `Store` do ObjectBox nem toca a rede.
- **Gate por tarefa:** `flutter analyze` sem erros novos e `flutter test` verde.
- **Mensagens de commit em português**, no imperativo, com os trailers do repositório:
  ```
  Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
  ```
- **Branch:** `feature-progresso-sincronizacao` (a atual).
- Textos de UI em português, sem abreviação.

---

### Task 1: Decisão de checkpoint (unidade pura)

**Files:**
- Create: `lib/core/sync/sync_checkpoint.dart`
- Test: `test/core/sync/sync_checkpoint_test.dart`

**Interfaces:**
- Consumes: `SyncEtapa` de `lib/core/sync/sync_etapa.dart`
- Produces: `SyncCheckpoint(Set<SyncEtapa> concluidas)` com `List<SyncEtapa> get pendentes`, `bool get tudoConcluido`, e `static String chaveDe(SyncEtapa)`

- [ ] **Step 1: Escrever o teste que falha**

```dart
// test/core/sync/sync_checkpoint_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_checkpoint.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';

void main() {
  group('SyncCheckpoint.pendentes', () {
    test('sem nada concluído, devolve as 8 etapas na ordem de execução', () {
      const c = SyncCheckpoint({});
      expect(c.pendentes, SyncEtapa.values);
      expect(c.pendentes.length, 8);
    });

    test('retoma da primeira etapa não concluída, preservando a ordem', () {
      const c = SyncCheckpoint({
        SyncEtapa.referencias,
        SyncEtapa.usuario,
        SyncEtapa.tecnico,
        SyncEtapa.produtores,
        SyncEtapa.propriedades,
      });
      expect(c.pendentes, [
        SyncEtapa.animais,
        SyncEtapa.acoes,
        SyncEtapa.financeiro,
      ]);
    });

    test('etapa concluída fora de ordem não reordena o restante', () {
      const c = SyncCheckpoint({SyncEtapa.animais});
      expect(c.pendentes, [
        SyncEtapa.referencias,
        SyncEtapa.usuario,
        SyncEtapa.tecnico,
        SyncEtapa.produtores,
        SyncEtapa.propriedades,
        SyncEtapa.acoes,
        SyncEtapa.financeiro,
      ]);
    });
  });

  group('SyncCheckpoint.tudoConcluido', () {
    test('falso quando falta ao menos uma etapa', () {
      const c = SyncCheckpoint({SyncEtapa.referencias});
      expect(c.tudoConcluido, false);
    });

    test('verdadeiro com todas as etapas marcadas', () {
      final c = SyncCheckpoint(SyncEtapa.values.toSet());
      expect(c.tudoConcluido, true);
    });
  });

  group('SyncCheckpoint.chaveDe', () {
    test('gera chave estável e distinta por etapa', () {
      expect(SyncCheckpoint.chaveDe(SyncEtapa.animais), 'etapa_animais');
      expect(SyncCheckpoint.chaveDe(SyncEtapa.financeiro), 'etapa_financeiro');
      final chaves = SyncEtapa.values.map(SyncCheckpoint.chaveDe).toSet();
      expect(chaves.length, SyncEtapa.values.length);
    });

    test('nenhuma chave colide com a linha agregadora initial_download', () {
      final chaves = SyncEtapa.values.map(SyncCheckpoint.chaveDe);
      expect(chaves.contains('initial_download'), false);
    });
  });
}
```

- [ ] **Step 2: Rodar o teste e confirmar que falha**

Run: `flutter test test/core/sync/sync_checkpoint_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:tecmuu/core/sync/sync_checkpoint.dart'`

- [ ] **Step 3: Implementar**

```dart
// lib/core/sync/sync_checkpoint.dart
import 'sync_etapa.dart';

/// Quais etapas do download completo ainda faltam.
///
/// Existe porque `performFullDownload` era tudo-ou-nada: uma falha na etapa
/// `animais` descartava as cinco anteriores e o próximo login rebaixava tudo
/// desde o começo. Sob restrição de quota isso nunca converge — cada tentativa
/// gasta o orçamento nas etapas que já tinham dado certo.
///
/// A decisão de "o que rodar agora" fica aqui, pura, porque o serviço de sync é
/// I/O puro e não se testa sem rede nem banco.
class SyncCheckpoint {
  const SyncCheckpoint(this.concluidas);

  /// Etapas já concluídas com sucesso, lidas das marcas persistidas.
  final Set<SyncEtapa> concluidas;

  /// Etapas que faltam, na ordem declarada em [SyncEtapa] — que é a ordem de
  /// execução e também a ordem de dependência (referências antes de tudo,
  /// técnico antes de animais).
  List<SyncEtapa> get pendentes =>
      SyncEtapa.values.where((e) => !concluidas.contains(e)).toList();

  bool get tudoConcluido => pendentes.isEmpty;

  /// Nome da linha em `SyncMetadataEntity` que guarda a marca da etapa. O
  /// prefixo evita colisão com as linhas de coleção já existentes
  /// (`initial_download`, `reparo_path_propriedades`).
  static String chaveDe(SyncEtapa etapa) => 'etapa_${etapa.name}';
}
```

- [ ] **Step 4: Rodar o teste e confirmar que passa**

Run: `flutter test test/core/sync/sync_checkpoint_test.dart`
Expected: PASS — 6 testes

- [ ] **Step 5: Commit**

```bash
git add lib/core/sync/sync_checkpoint.dart test/core/sync/sync_checkpoint_test.dart
git commit -m "$(cat <<'EOF'
Adiciona SyncCheckpoint para retomada por etapa

Unidade pura que decide quais etapas do download completo ainda faltam. A
decisao fica separada do OfflineFirstSyncService, que e I/O puro e nao se
testa sem rede nem banco.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 2: Classificação de erro de cota (unidade pura)

**Files:**
- Modify: `lib/core/sync/sync_exceptions.dart`
- Test: `test/core/sync/sync_exceptions_test.dart` (arquivo existente — acrescentar grupo)

**Interfaces:**
- Consumes: `SyncEtapa`, `FirebaseException` de `package:firebase_core/firebase_core.dart`
- Produces: `SyncCotaExcedidaException(SyncEtapa? etapa, Object causa)` com `String get mensagem`; `bool ehErroDeCota(Object erro)`

- [ ] **Step 1: Escrever o teste que falha**

Acrescentar ao final de `test/core/sync/sync_exceptions_test.dart`, dentro do `main()` existente:

```dart
  group('ehErroDeCota', () {
    test('reconhece FirebaseException com code resource-exhausted', () {
      final e = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'resource-exhausted',
        message: 'Quota exceeded.',
      );
      expect(ehErroDeCota(e), true);
    });

    test('nao confunde com outros codigos do Firebase', () {
      final e = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      );
      expect(ehErroDeCota(e), false);
    });

    test('nao reconhece erro generico', () {
      expect(ehErroDeCota(StateError('qualquer coisa')), false);
    });

    test('reconhece pelo texto quando a excecao vem embrulhada pela plataforma',
        () {
      // O canal Android entrega PlatformException, cuja mensagem carrega
      // RESOURCE_EXHAUSTED mas cujo `code` nao e o do Firestore.
      expect(ehErroDeCota(Exception('RESOURCE_EXHAUSTED: Quota exceeded.')),
          true);
    });
  });

  group('SyncCotaExcedidaException', () {
    test('carrega a etapa em que parou', () {
      const e = SyncCotaExcedidaException(SyncEtapa.animais, 'x');
      expect(e.etapa, SyncEtapa.animais);
    });

    test('mensagem expoe a causa', () {
      const e = SyncCotaExcedidaException(SyncEtapa.animais, 'estourou');
      expect(e.mensagem, contains('estourou'));
    });
  });
```

Acrescentar o import no topo do arquivo de teste:

```dart
import 'package:firebase_core/firebase_core.dart';
```

- [ ] **Step 2: Rodar o teste e confirmar que falha**

Run: `flutter test test/core/sync/sync_exceptions_test.dart`
Expected: FAIL — `Undefined name 'ehErroDeCota'`

- [ ] **Step 3: Implementar**

Acrescentar ao final de `lib/core/sync/sync_exceptions.dart`, e acrescentar o import `import 'package:firebase_core/firebase_core.dart';` no topo:

```dart
/// A cota do Firestore foi atingida no meio do download completo.
///
/// Distinta de [SyncFalhaException] porque nao e falha do app nem do dado: os
/// registros baixados ate aqui sao validos e o usuario pode entrar. A tela
/// avisa em vez de bloquear, e a retomada por etapa cuida do restante.
class SyncCotaExcedidaException implements Exception {
  const SyncCotaExcedidaException(this.etapa, this.causa);

  final SyncEtapa? etapa;
  final Object causa;

  String get mensagem => causa.toString();

  @override
  String toString() => 'SyncCotaExcedidaException($etapa): $mensagem';
}

/// `true` quando o erro e esgotamento de cota do Firestore.
///
/// Checa duas formas porque o erro chega diferente conforme a camada: o SDK
/// devolve `FirebaseException(code: 'resource-exhausted')`, mas o canal da
/// plataforma no Android embrulha em `PlatformException` e o codigo original
/// so sobrevive no texto.
bool ehErroDeCota(Object erro) {
  if (erro is FirebaseException && erro.code == 'resource-exhausted') {
    return true;
  }
  final texto = erro.toString();
  return texto.contains('RESOURCE_EXHAUSTED') ||
      texto.contains('resource-exhausted');
}
```

- [ ] **Step 4: Rodar o teste e confirmar que passa**

Run: `flutter test test/core/sync/sync_exceptions_test.dart`
Expected: PASS — os testes existentes mais 6 novos

- [ ] **Step 5: Commit**

```bash
git add lib/core/sync/sync_exceptions.dart test/core/sync/sync_exceptions_test.dart
git commit -m "$(cat <<'EOF'
Distingue erro de cota do Firestore de falha de sincronizacao

Cota atingida nao e falha do app nem do dado: o que foi baixado e valido e o
usuario pode entrar. Reconhece as duas formas em que o erro chega (SDK e canal
da plataforma no Android).

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 3: `performFullDownload` em laço com checkpoint

**Files:**
- Modify: `lib/data/objectbox/offline_first_sync_service.dart:156-222` (o método) e acrescentar dois helpers privados

**Interfaces:**
- Consumes: `SyncCheckpoint` (Task 1), `SyncCotaExcedidaException`/`ehErroDeCota` (Task 2)
- Produces: `performFullDownload` com a mesma assinatura pública; nenhum consumidor externo muda

**Contexto que o implementador precisa:** as oito etapas de `SyncEtapa` mapeiam para estes trechos do método atual — `referencias` → `_downloadReferenceTables()`; `usuario` → `_downloadPerson(userId)`; `tecnico` → `_downloadTecnico(userId)`; `produtores` → `_downloadProdutoresDoTecnico(tecnicoRef)` ou `_downloadProdutor(userId)`; `propriedades` → `_downloadTodasPropriedades(tecnicoRef, userId)`; `animais` → `_downloadTodosAnimais(tecnicoRef)`; `acoes` → `_downloadAcoes(tecnicoRef)`; `financeiro` → `_downloadFinanceiroEVisitas()`.

A etapa `tecnico` produz o `DocumentReference?` que quatro etapas seguintes consomem. Quando ela é pulada por já estar concluída, a referência é remontada a partir do ObjectBox — zero leituras de rede.

- [ ] **Step 1: Acrescentar os helpers de marca e a remontagem do tecnicoRef**

Acrescentar em `OfflineFirstSyncService`, logo acima de `performFullDownload`:

```dart
  /// Etapas já concluídas, lidas das marcas persistidas.
  Set<SyncEtapa> _etapasConcluidas() {
    final marcas = <SyncEtapa>{};
    for (final etapa in SyncEtapa.values) {
      final linha = _objectBox.syncMetadataBox
          .query(SyncMetadataEntity_.collectionName
              .equals(SyncCheckpoint.chaveDe(etapa)))
          .build()
          .findFirst();
      if (linha != null && linha.initialSyncComplete) marcas.add(etapa);
    }
    return marcas;
  }

  /// Fecha as marcas de etapa ao fim de um download completo bem-sucedido.
  ///
  /// Duas coisas acontecem aqui, e as duas importam:
  ///
  /// 1. `initialSyncComplete` volta a `false`, para que um próximo
  ///    `performFullDownload` (troca de aparelho, logout/login) recomece do
  ///    zero em vez de achar que já baixou tudo.
  /// 2. `lastIncrementalSync` recebe AGORA. Sem isso o primeiro pull
  ///    incremental veria a marca nula, cairia em `JanelaPull.epoca` e
  ///    rebaixaria a base inteira cinco minutos depois de terminar o download
  ///    completo — justamente o consumo que este trabalho quer eliminar.
  ///
  /// `_updateSyncMetadata` não serve aqui: ele só sabe LIGAR o
  /// `initialSyncComplete`, nunca desligar.
  void _fecharMarcasDeEtapa() {
    final agora = DateTime.now().toUtc();
    for (final etapa in SyncEtapa.values) {
      final chave = SyncCheckpoint.chaveDe(etapa);
      final linha = _objectBox.syncMetadataBox
              .query(SyncMetadataEntity_.collectionName.equals(chave))
              .build()
              .findFirst() ??
          SyncMetadataEntity(collectionName: chave);
      linha.initialSyncComplete = false;
      linha.lastIncrementalSync = agora;
      _objectBox.syncMetadataBox.put(linha);
    }
  }

  /// Referência do técnico LOGADO, remontada do ObjectBox sem ida à rede.
  ///
  /// Usada em dois lugares: quando a etapa `tecnico` foi pulada por já ter
  /// concluído, e no pull incremental.
  ///
  /// O filtro por `uidPerson` não é detalhe: o cache de um aparelho de PRODUTOR
  /// também contém o documento do técnico dele. Pegar "o primeiro técnico da
  /// box" faria o pull baixar o rebanho inteiro daquele técnico — animais de
  /// outros produtores. Casando com o usuário logado, isto devolve `null` em
  /// aparelho de produtor, e o pull vira no-op ali (produtor continua servido
  /// pelo download completo).
  DocumentReference? _tecnicoRefLocal() {
    final userId = _lastUserId ?? FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return null;

    final tecnico = _objectBox.tecnicoBox
        .query(TecnicoEntity_.uidPerson.equals(userId))
        .build()
        .findFirst();

    final firestoreId = tecnico?.firestoreId;
    if (firestoreId == null) return null;
    return _firestore.doc('tecnico/$firestoreId');
  }
```

Acrescentar os imports no topo do arquivo:

```dart
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/sync/sync_checkpoint.dart';
```

(`sync_etapa.dart` e `sync_exceptions.dart` já estão importados. Conferir se `firebase_auth` já vem por outro import antes de duplicar.)

- [ ] **Step 2: Reescrever `performFullDownload` como laço**

Substituir o corpo inteiro de `performFullDownload` (linhas 156-222) por:

```dart
  Future<void> performFullDownload({
    required String userId,
    SyncProgressCallback? onProgress,
  }) async {
    _lastUserId = userId;
    if (!_isOnline) {
      debugPrint('📴 Offline - download adiado');
      _updateStatus(SyncStatus.offline);
      throw const SyncOfflineException();
    }

    _updateStatus(SyncStatus.syncing);

    final checkpoint = SyncCheckpoint(_etapasConcluidas());
    if (checkpoint.concluidas.isNotEmpty) {
      debugPrint(
          '↻ Retomando download: ${checkpoint.pendentes.length} etapa(s) '
          'pendente(s) de ${SyncEtapa.values.length}');
    }

    // A referência do técnico é produzida pela etapa `tecnico` e consumida por
    // quatro etapas seguintes. Se aquela etapa já concluiu numa tentativa
    // anterior, remonta do ObjectBox em vez de rebaixar o documento.
    DocumentReference? tecnicoRef =
        checkpoint.concluidas.contains(SyncEtapa.tecnico)
            ? _tecnicoRefLocal()
            : null;

    SyncEtapa? etapaAtual;
    try {
      for (final etapa in checkpoint.pendentes) {
        etapaAtual = etapa;
        switch (etapa) {
          case SyncEtapa.referencias:
            _reportProgress(etapa, 'Tabelas de referência');
            await _downloadReferenceTables();
          case SyncEtapa.usuario:
            _reportProgress(etapa, 'Seus dados');
            await _downloadPerson(userId);
          case SyncEtapa.tecnico:
            _reportProgress(etapa, 'Dados do técnico');
            tecnicoRef = await _downloadTecnico(userId);
          case SyncEtapa.produtores:
            _reportProgress(etapa, 'Produtores');
            if (tecnicoRef != null) {
              await _downloadProdutoresDoTecnico(tecnicoRef);
            } else {
              await _downloadProdutor(userId);
            }
          case SyncEtapa.propriedades:
            _reportProgress(etapa, 'Propriedades');
            await _downloadTodasPropriedades(tecnicoRef, userId);
          case SyncEtapa.animais:
            await _downloadTodosAnimais(tecnicoRef);
          case SyncEtapa.acoes:
            await _downloadAcoes(tecnicoRef);
          case SyncEtapa.financeiro:
            _reportProgress(etapa, 'Financeiro e visitas');
            await _downloadFinanceiroEVisitas();
        }
        _updateSyncMetadata(SyncCheckpoint.chaveDe(etapa), DateTime.now(),
            complete: true);
      }

      _updateSyncMetadata('initial_download', DateTime.now(), complete: true);
      // O download acima já gravou as propriedades no path correto — dispensa o
      // reparo pontual em instalações novas.
      _updateSyncMetadata(_kReparoPathPropriedades, DateTime.now(),
          complete: true);
      _initialSyncComplete = true;
      // As marcas cumpriram seu papel. Zerá-las deixa um próximo download
      // completo recomeçar do zero, e carimbar `lastIncrementalSync` evita que
      // o primeiro pull rebaixe a base inteira.
      _fecharMarcasDeEtapa();

      _reportProgress(SyncEtapa.financeiro, 'Concluído', atual: 1, total: 1);
      _updateStatus(SyncStatus.completed);
    } on SyncOfflineException {
      rethrow;
    } catch (e) {
      _updateStatus(SyncStatus.error);
      if (ehErroDeCota(e)) {
        debugPrint('⚠️ Cota do Firestore atingida na etapa $etapaAtual: $e');
        throw SyncCotaExcedidaException(etapaAtual, e);
      }
      debugPrint('❌ Erro no download completo (etapa $etapaAtual): $e');
      throw SyncFalhaException(etapaAtual, e);
    }
  }
```

Nota: a `SyncFalhaException` passa a receber `etapaAtual` em vez de `_lastProgress?.etapa`. É mais preciso — `_lastProgress` reflete o último progresso reportado, que nas etapas `animais` e `acoes` pode estar defasado.

- [ ] **Step 3: Verificar que compila e que a suíte segue verde**

Run: `flutter analyze lib/data/objectbox/offline_first_sync_service.dart && flutter test`
Expected: analyze sem erros; todos os testes passam (os de `sync_page_controller` cobrem o contrato de exceções e não devem quebrar)

- [ ] **Step 4: Commit**

```bash
git add lib/data/objectbox/offline_first_sync_service.dart
git commit -m "$(cat <<'EOF'
Faz o download completo retomar da etapa que faltou

performFullDownload era tudo-ou-nada: falha na etapa animais descartava as cinco
anteriores e o proximo login rebaixava tudo. Agora cada etapa grava sua marca e
a retomada comeca na primeira pendente. A referencia do tecnico e remontada do
ObjectBox quando a etapa dela ja concluiu, sem ida a rede.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 4: `count()` best-effort

**Files:**
- Modify: `lib/data/objectbox/offline_first_sync_service.dart:523-568` (`_downloadTodosAnimais`)

**Interfaces:**
- Consumes: nada novo
- Produces: `_baixarAnimaisPaginado` passa a aceitar `int? total` em vez de `int total`

**Contexto:** `_reportProgress` já aceita `int? total` (linha 131-135) e `progressoGlobal` já devolve `etapa.inicio` quando `total` é nulo (`sync_etapa.dart`). `SyncBaixando.temContador` já trata nulo. Nada mais precisa mudar rio abaixo.

- [ ] **Step 1: Extrair o `count()` para um helper tolerante**

Acrescentar em `OfflineFirstSyncService`, logo acima de `_downloadTodosAnimais`:

```dart
  /// Total de documentos da consulta, ou `null` se a contagem falhar.
  ///
  /// O total alimenta APENAS a barra de progresso — a paginação em
  /// `_baixarAnimaisPaginado` não depende dele. Antes, um `count()` que falhasse
  /// derrubava o download inteiro de animais antes da primeira página: um
  /// indicador cosmético matando a sincronização.
  Future<int?> _contarOuNulo(Query<Map<String, dynamic>> consulta) async {
    try {
      return (await consulta.count().get()).count;
    } catch (e) {
      debugPrint('⚠️ count() indisponível, progresso indeterminado: $e');
      return null;
    }
  }
```

- [ ] **Step 2: Usar o helper nos dois ramos**

Em `_downloadTodosAnimais`, ramo do técnico, trocar:

```dart
      final total = (await colecao.count().get()).count ?? 0;
```

por:

```dart
      final total = await _contarOuNulo(colecao);
```

No ramo do produtor, trocar:

```dart
      var total = 0;
      for (final consulta in consultas.values) {
        total += (await consulta.count().get()).count ?? 0;
      }
```

por:

```dart
      // Soma o que der para contar; qualquer contagem que falhe torna o total
      // desconhecido, e a barra fica indeterminada em vez de mentir.
      int? total = 0;
      for (final consulta in consultas.values) {
        final parcial = await _contarOuNulo(consulta);
        if (parcial == null) {
          total = null;
          break;
        }
        total = total! + parcial;
      }
```

- [ ] **Step 3: Afrouxar a assinatura de `_baixarAnimaisPaginado`**

Trocar o parâmetro `int total` por `int? total` na assinatura, e conferir que o `_reportProgress` dentro do laço já repassa `total:` sem conversão. Nenhuma outra mudança é necessária — `atual` continua sendo o acumulado real.

- [ ] **Step 4: Verificar**

Run: `flutter analyze lib/data/objectbox/offline_first_sync_service.dart && flutter test`
Expected: analyze sem erros; testes verdes

- [ ] **Step 5: Commit**

```bash
git add lib/data/objectbox/offline_first_sync_service.dart
git commit -m "$(cat <<'EOF'
Torna o count() de animais best-effort

O total alimenta so a barra de progresso, mas uma aggregation query que falhasse
derrubava o download de animais antes da primeira pagina. Agora a falha vira
barra indeterminada e o download segue.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 5: Tela de sincronização trata cota como aviso

**Files:**
- Modify: `lib/features/sincronizacao/domain/sync_state.dart` (novo valor em `SyncErroTipo`)
- Modify: `lib/features/sincronizacao/presentation/controllers/sync_page_controller.dart:70-90`
- Modify: `lib/features/sincronizacao/presentation/widgets/sync_progress_view.dart` (texto do aviso)
- Test: `test/features/sincronizacao/sync_page_controller_test.dart` (acrescentar grupo)

**Interfaces:**
- Consumes: `SyncCotaExcedidaException` (Task 2)
- Produces: `SyncErroTipo.cotaExcedida`; `SyncErro.podeContinuarAssimMesmo` passa a ser `true` também para esse tipo

- [ ] **Step 1: Escrever o teste que falha**

Acrescentar em `test/features/sincronizacao/sync_page_controller_test.dart`, dentro do `main()`:

```dart
  group('cota excedida', () {
    test('vira estado de erro do tipo cotaExcedida, nao falhaDownload',
        () async {
      final fake = FakeSyncGateway(
        erroAoBaixar:
            const SyncCotaExcedidaException(SyncEtapa.animais, 'Quota exceeded'),
      );
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(null);

      final estado = c.read(syncPageControllerProvider);
      expect(estado, isA<SyncErro>());
      expect((estado as SyncErro).tipo, SyncErroTipo.cotaExcedida);
      expect(estado.etapa, SyncEtapa.animais);
    });

    test('permite continuar assim mesmo', () async {
      final fake = FakeSyncGateway(
        erroAoBaixar:
            const SyncCotaExcedidaException(SyncEtapa.animais, 'Quota exceeded'),
      );
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(null);

      final estado = c.read(syncPageControllerProvider) as SyncErro;
      expect(estado.podeContinuarAssimMesmo, true);
    });

    test('continuar assim mesmo conclui o login com os dados parciais',
        () async {
      final fake = FakeSyncGateway(
        erroAoBaixar:
            const SyncCotaExcedidaException(SyncEtapa.animais, 'Quota exceeded'),
      );
      final c = containerCom(fake);
      await c.read(syncPageControllerProvider.notifier).iniciar(null);

      await c.read(syncPageControllerProvider.notifier).continuarAssimMesmo();

      expect(c.read(syncPageControllerProvider), isA<SyncConcluido>());
      expect(fake.vezesQueConcluiu, 1);
    });
  });
```

- [ ] **Step 2: Rodar e confirmar que falha**

Run: `flutter test test/features/sincronizacao/sync_page_controller_test.dart`
Expected: FAIL — `SyncErroTipo.cotaExcedida` não existe

- [ ] **Step 3: Acrescentar o tipo de erro**

Em `lib/features/sincronizacao/domain/sync_state.dart`, no enum `SyncErroTipo`:

```dart
enum SyncErroTipo {
  /// Uma etapa quebrou. Ha dados parciais gravados.
  falhaDownload,

  /// Offline e sem nada baixado ainda. Nao ha dado parcial com que continuar.
  semConexao,

  /// A cota do Firestore foi atingida. Os dados baixados ate aqui sao validos e
  /// o restante desce na proxima tentativa, a partir da etapa que faltou.
  cotaExcedida,
}
```

E em `SyncErro`, ampliar o predicado:

```dart
  bool get podeContinuarAssimMesmo =>
      tipo == SyncErroTipo.falhaDownload || tipo == SyncErroTipo.cotaExcedida;
```

- [ ] **Step 4: Tratar a exceção no controller**

Em `sync_page_controller.dart`, dentro do `_executar`, acrescentar o `on` ANTES do `on SyncFalhaException` (a ordem importa: são tipos irmãos, mas manter o mais específico primeiro deixa a intenção explícita):

```dart
      } on SyncCotaExcedidaException catch (e) {
        state = SyncErro(
          tipo: SyncErroTipo.cotaExcedida,
          etapa: e.etapa,
          mensagem: e.mensagem,
        );
        return;
      } on SyncFalhaException catch (e) {
```

Acrescentar o import de `SyncCotaExcedidaException` (já vem de `core/sync/sync_exceptions.dart`, que o arquivo importa).

- [ ] **Step 5: Ajustar o texto na view**

Em `sync_progress_view.dart:276`, onde hoje há `'Falhou ao baixar: ${rotuloLinha(e.etapa!)}.'`, ramificar por tipo:

```dart
            ? (e.tipo == SyncErroTipo.cotaExcedida
                ? 'A cota diária do Firebase foi atingida. Seus dados até aqui '
                    'foram salvos e você pode usar o app normalmente. '
                    'O restante será baixado automaticamente.'
                : 'Falhou ao baixar: ${rotuloLinha(e.etapa!)}.')
```

O implementador deve ler o trecho ao redor da linha 276 e encaixar a condição na estrutura existente, preservando o ramo que já trata `e.etapa == null`.

- [ ] **Step 6: Rodar e confirmar que passa**

Run: `flutter test`
Expected: PASS — toda a suíte

- [ ] **Step 7: Commit**

```bash
git add lib/features/sincronizacao test/features/sincronizacao
git commit -m "$(cat <<'EOF'
Trata cota do Firestore como aviso, nao como falha

Cota atingida deixa de bloquear a entrada: a tela avisa, oferece continuar com
os dados parciais e a proxima tentativa retoma da etapa que faltou.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 6: Carimbar `lastModified` nas escritas para o Firestore

**Files:**
- Modify: `lib/data/objectbox/repositories/base_sync_repository.dart` (`firestorePayloadFor`)
- Test: `test/repositories/base_sync_repository_test.dart` (acrescentar grupo)

**Interfaces:**
- Consumes: nada novo
- Produces: todo payload de escrita passa a conter a chave `lastModified` com `FieldValue.serverTimestamp()`

**Contexto:** hoje `firestorePayloadFor(E entity) => entity.toFirestore()` (linha 156). Nenhum `toFirestore()` das entidades escreve timestamp de modificação, e por isso a Task 7 não teria sobre o que filtrar. O carimbo é do servidor, não do relógio do aparelho.

- [ ] **Step 1: Escrever o teste que falha**

Acrescentar em `test/repositories/base_sync_repository_test.dart`:

```dart
  group('BaseSyncRepository.carimbarLastModified', () {
    test('acrescenta lastModified ao payload', () {
      final payload = BaseSyncRepository.carimbarLastModified({'nome': 'Mimosa'});
      expect(payload.containsKey('lastModified'), true);
    });

    test('preserva os campos originais', () {
      final payload =
          BaseSyncRepository.carimbarLastModified({'nome': 'Mimosa', 'peso': 3});
      expect(payload['nome'], 'Mimosa');
      expect(payload['peso'], 3);
    });

    test('nao muta o mapa recebido', () {
      final original = <String, dynamic>{'nome': 'Mimosa'};
      BaseSyncRepository.carimbarLastModified(original);
      expect(original.containsKey('lastModified'), false);
    });

    test('sobrescreve lastModified preexistente com o carimbo do servidor', () {
      final payload = BaseSyncRepository.carimbarLastModified(
          {'lastModified': 'texto qualquer'});
      expect(payload['lastModified'], isNot('texto qualquer'));
    });
  });
```

Acrescentar o import `import 'package:cloud_firestore/cloud_firestore.dart';` se necessário para o analyze.

- [ ] **Step 2: Rodar e confirmar que falha**

Run: `flutter test test/repositories/base_sync_repository_test.dart`
Expected: FAIL — `carimbarLastModified` não definido

- [ ] **Step 3: Implementar**

Em `base_sync_repository.dart`, acrescentar o helper estático e passar a usá-lo:

```dart
  /// Acrescenta o carimbo de modificação ao payload, sem mutar o original.
  ///
  /// Existe porque `lastModified` é campo só local do ObjectBox: nenhum
  /// `toFirestore()` o escrevia, e sem ele no documento o pull incremental não
  /// teria sobre o que filtrar. O carimbo é do servidor para não depender do
  /// relógio do aparelho, que em campo costuma estar errado.
  static Map<String, dynamic> carimbarLastModified(
    Map<String, dynamic> payload,
  ) =>
      {...payload, 'lastModified': FieldValue.serverTimestamp()};

  /// Payload gravado no Firestore.
  @protected
  Map<String, dynamic> firestorePayloadFor(E entity) =>
      carimbarLastModified(entity.toFirestore());
```

- [ ] **Step 4: Aplicar o mesmo carimbo nas escritas do sync service**

Em `offline_first_sync_service.dart`, os métodos `_syncModified*` montam payloads próprios. Em cada um, envolver o mapa enviado ao Firestore com `BaseSyncRepository.carimbarLastModified(...)`. O implementador deve localizar cada chamada `.set(`/`.update(` nesses métodos (`_syncModifiedPropriedades`, `_syncModifiedAnimals`, `_syncModifiedAcoes`, `_syncModifiedTratamentos`, `_syncModifiedFinanceiro`, `_syncModifiedVisitas`) e aplicar. Exemplo em `_propriedadePayload` (linha ~880):

```dart
  Map<String, dynamic> _propriedadePayload(PropriedadeEntity prop) {
    final data = prop.toFirestore();
    if (prop.uidPersonProdutorPath != null) {
      data['uidPersonProdutor'] = _firestore.doc(prop.uidPersonProdutorPath!);
    }
    return BaseSyncRepository.carimbarLastModified(data);
  }
```

Acrescentar o import de `base_sync_repository.dart` no sync service.

- [ ] **Step 5: Rodar e confirmar que passa**

Run: `flutter test && flutter analyze lib/data/objectbox`
Expected: PASS; analyze sem erros. O teste de round-trip do `AnimaisProdutoresStruct` deve continuar verde — `lastModified` entra no payload de escrita, não no `updateFromFirestore`.

- [ ] **Step 6: Commit**

```bash
git add lib/data/objectbox test/repositories/base_sync_repository_test.dart
git commit -m "$(cat <<'EOF'
Carimba lastModified do servidor nas escritas ao Firestore

lastModified era campo so local do ObjectBox e nenhum documento no Firestore o
tinha. Sem ele o pull incremental nao teria sobre o que filtrar. Carimbo do
servidor para nao depender do relogio do aparelho.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 7: Pull incremental substitui os listeners

**Files:**
- Modify: `lib/data/objectbox/offline_first_sync_service.dart` (novo `_pullRemoteChanges`, chamado de `startPeriodicSync` e do listener de conectividade)
- Modify: `lib/features/sincronizacao/data/offline_first_sync_gateway.dart:86-91` (remover `startAllListeners`)
- Create: `lib/core/sync/janela_pull.dart`
- Test: `test/core/sync/janela_pull_test.dart`

**Interfaces:**
- Consumes: `SyncCheckpoint.chaveDe` (Task 1), `lastModified` nos documentos (Task 6)
- Produces: `JanelaPull.desde(DateTime? ultimaSync)` → `DateTime`; `OfflineFirstSyncService._pullRemoteChanges()`

**Contexto:** `startPeriodicSync` (linha 1444) hoje só chama `syncPendingChangesToFirestore`, que é exclusivamente push. Sem os listeners, nada traria alterações remotas.

- [ ] **Step 1: Escrever o teste da janela (unidade pura)**

```dart
// test/core/sync/janela_pull_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/janela_pull.dart';

void main() {
  group('JanelaPull.desde', () {
    test('recua a margem de segurança sobre a última sincronização', () {
      final ultima = DateTime.utc(2026, 8, 10, 12, 0, 0);
      expect(
        JanelaPull.desde(ultima),
        ultima.subtract(JanelaPull.margem),
      );
    });

    test('sem sincronização anterior, usa a época para trazer tudo', () {
      expect(JanelaPull.desde(null), JanelaPull.epoca);
    });

    test('margem é positiva — janela que não recua perde escritas em voo', () {
      expect(JanelaPull.margem, greaterThan(Duration.zero));
    });
  });
}
```

- [ ] **Step 2: Rodar e confirmar que falha**

Run: `flutter test test/core/sync/janela_pull_test.dart`
Expected: FAIL — arquivo não existe

- [ ] **Step 3: Implementar a janela**

```dart
// lib/core/sync/janela_pull.dart

/// A partir de quando buscar alterações remotas no pull incremental.
///
/// A janela recua uma margem sobre a última sincronização em vez de usar o
/// instante exato. Sem isso, um documento cujo `serverTimestamp` cai entre a
/// leitura e a gravação da marca ficaria para sempre fora de toda janela
/// futura — perdido em silêncio. Reprocessar alguns documentos é barato; o
/// upsert é idempotente.
class JanelaPull {
  const JanelaPull._();

  /// Recuo aplicado sobre a última sincronização.
  static const Duration margem = Duration(minutes: 2);

  /// Início dos tempos, para quando nunca houve sincronização.
  static final DateTime epoca = DateTime.utc(1970);

  static DateTime desde(DateTime? ultimaSync) =>
      ultimaSync == null ? epoca : ultimaSync.subtract(margem);
}
```

- [ ] **Step 4: Rodar e confirmar que passa**

Run: `flutter test test/core/sync/janela_pull_test.dart`
Expected: PASS — 3 testes

- [ ] **Step 5: Implementar o pull no sync service**

Acrescentar em `OfflineFirstSyncService`:

```dart
  /// Traz do Firestore o que mudou desde a última sincronização.
  ///
  /// Substitui os listeners `.snapshots()` permanentes (um por coleção mais um
  /// por propriedade — 40 numa conta com 38 propriedades), que reliam coleções
  /// inteiras a cada attach. Aqui são três queries delta, trazendo só o que
  /// mudou.
  ///
  /// Documentos sem o campo `lastModified` são invisíveis a um filtro de
  /// intervalo. Isso é esperado: o carimbo só passou a existir a partir da
  /// versão que introduziu o pull, e o download completo (sem filtro) continua
  /// trazendo a base inteira no primeiro login.
  Future<void> _pullRemoteChanges() async {
    if (!_isOnline) return;

    final tecnicoRef = _tecnicoRefLocal();
    if (tecnicoRef == null) return;

    await _pullColecao(
      etapa: SyncEtapa.animais,
      consulta: (desde) => tecnicoRef
          .collection('animaisProdutores')
          .where('lastModified', isGreaterThan: Timestamp.fromDate(desde)),
      aplicar: (docs) => _salvarAnimais(docs, tecnicoRef.path),
    );

    await _pullColecao(
      etapa: SyncEtapa.acoes,
      consulta: (desde) => tecnicoRef
          .collection('acoes')
          .where('lastModified', isGreaterThan: Timestamp.fromDate(desde)),
      aplicar: (docs) => _salvarAcoes(docs, tecnicoRef.path),
    );
  }

  /// Grava ações baixadas reaproveitando o `id` local das que já existem.
  ///
  /// `AcaoEntity.firestoreId` é `@Unique` e `fromFirestore` devolve sempre
  /// `id = 0`. Um `putMany` direto seria INSERT e, no segundo pull do mesmo
  /// documento, estouraria a constraint — que é exatamente o problema que
  /// `reaproveitarIds` já resolve para as tabelas de referência.
  void _salvarAcoes(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String parentPath,
  ) {
    if (docs.isEmpty) return;

    final ids = docs.map((d) => d.id).toList();
    final existentes = _objectBox.acaoBox
        .query(AcaoEntity_.firestoreId.oneOf(ids))
        .build()
        .find();

    final baixados = [
      for (final doc in docs)
        AcaoEntity.fromFirestore(doc.data(), doc.id, parentPath),
    ];

    reaproveitarIds<AcaoEntity>(
      existentes: existentes,
      baixados: baixados,
      firestoreIdDe: (e) => e.firestoreId,
      idDe: (e) => e.id,
      definirId: (e, id) => e.id = id,
    );

    _objectBox.acaoBox.putMany(baixados);
  }

  /// Executa o delta de UMA coleção e avança a marca dela.
  Future<void> _pullColecao({
    required SyncEtapa etapa,
    required Query<Map<String, dynamic>> Function(DateTime desde) consulta,
    required void Function(List<QueryDocumentSnapshot<Map<String, dynamic>>>)
        aplicar,
  }) async {
    final chave = SyncCheckpoint.chaveDe(etapa);
    final marca = _objectBox.syncMetadataBox
        .query(SyncMetadataEntity_.collectionName.equals(chave))
        .build()
        .findFirst();
    final desde = JanelaPull.desde(marca?.lastIncrementalSync);

    try {
      final snapshot = await consulta(desde).get();
      if (snapshot.docs.isNotEmpty) {
        aplicar(snapshot.docs);
        debugPrint('↓ ${snapshot.docs.length} ${etapa.name} atualizado(s)');
      }
      final linha = marca ?? SyncMetadataEntity(collectionName: chave);
      linha.lastIncrementalSync = DateTime.now().toUtc();
      _objectBox.syncMetadataBox.put(linha);
    } catch (e) {
      // Pull é oportunista: falhar aqui não pode derrubar o push que vem em
      // seguida nem marcar o app como quebrado.
      debugPrint('⚠️ Pull de ${etapa.name} falhou: $e');
    }
  }
```

Nota: `_downloadAcoes` (linha 668) hoje faz `_objectBox.acaoBox.putMany([...fromFirestore])` direto. Ele funciona no download completo porque o cache costuma estar vazio, mas tem a mesma fragilidade da constraint única. Ao introduzir `_salvarAcoes`, trocar também aquele bloco para usá-lo — assim o download completo deixa de estourar no segundo download do aparelho.

Tratamentos ficam fora deste pull: vivem sob cada propriedade e exigiriam uma query por propriedade, que é exatamente o custo que se quer eliminar. Eles descem no download completo.

Acrescentar os imports `import '../../core/sync/janela_pull.dart';` e `import '../../core/sync/upsert_referencia.dart';` (este último se ainda não estiver presente).

- [ ] **Step 6: Ligar o pull ao ciclo periódico**

Em `startPeriodicSync` (linha 1444), acrescentar o pull antes do push:

```dart
  void startPeriodicSync({Duration interval = const Duration(minutes: 5)}) {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(interval, (_) async {
      if (_isOnline) {
        await _pullRemoteChanges();
        await syncPendingChangesToFirestore();
      }
    });
  }
```

E no listener de conectividade (`_setupConnectivityListener`, linha 96), acrescentar a mesma chamada de pull no ramo que reage a "voltou a ficar online", antes do push que já existe ali.

- [ ] **Step 7: Desligar os listeners**

Em `offline_first_sync_gateway.dart`, remover o bloco das linhas 86-91:

```dart
    // Sincronização em tempo real Firestore->ObjectBox: reflete mudanças
    // remotas (ex.: outro dispositivo) automaticamente. Só nativo.
    if (ObjectBoxService.isInitialized) {
      await RemoteSyncListenersService.initialize();
      RemoteSyncListenersService.instance
          .startAllListeners(tecnico.reference.path);
    }
```

Remover o import de `RemoteSyncListenersService` do arquivo se ficar sem uso. **Não** remover o arquivo `remote_sync_listeners_service.dart` — está fora de escopo. O uso em `profile_tecnico_page.dart:1053` (`dispose` defensivo) permanece e continua válido.

- [ ] **Step 8: Atualizar a documentação de arquitetura**

Em `ARCHITECTURE.md`, o comentário sobre `remote_sync_listeners_service.dart` diz "(HOJE INATIVO)". Passou a ser verdade — mas por outro motivo. Trocar por:

```
    remote_sync_listeners_service.dart  listeners Firestore->ObjectBox (SEM CHAMADOR
                                        desde 2026-08-10: substituidos pelo pull
                                        incremental em startPeriodicSync)
```

- [ ] **Step 9: Verificar**

Run: `flutter analyze && flutter test`
Expected: sem erros; suíte verde

- [ ] **Step 10: Commit**

```bash
git add lib/core/sync/janela_pull.dart test/core/sync/janela_pull_test.dart lib/data/objectbox/offline_first_sync_service.dart lib/features/sincronizacao/data/offline_first_sync_gateway.dart ARCHITECTURE.md
git commit -m "$(cat <<'EOF'
Troca os 40 listeners permanentes por pull incremental

startAllListeners abria um listener por colecao mais um por propriedade (40 numa
conta com 38 propriedades), e cada attach relia a colecao inteira. No lugar, duas
queries delta no ciclo periodico que ja existia, filtrando por lastModified.

A janela recua uma margem sobre a ultima sincronizacao: sem isso, um documento
cujo serverTimestamp cai entre a leitura e a gravacao da marca ficaria fora de
toda janela futura.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 8: Dashboard conta animais pelo ObjectBox

**Files:**
- Modify: `lib/features/animais/application/animais_providers.dart` (criar se não existir)
- Modify: `lib/features/dashboard/presentation/pages/dashboard_tecnico_page.dart:312-340`

**Interfaces:**
- Consumes: `animalRepositoryProvider` (`core/di/providers.dart:65`), `ehDescarte` (`domain/animais/classificacao_animal.dart:59`)
- Produces: `animaisAtivosCountProvider` — `StreamProvider.family<int, String>`, parâmetro é o `tecnicoPath` (`tecnico/{id}`)

**Contexto:** hoje a tela usa `StreamBuilder<List<AnimaisProdutoresRecord>>` sobre `queryAnimaisProdutoresRecord(parent: tecnicoRecord.docRef)`, e `queryCollection` (`backend.dart:2255`) devolve `query.snapshots()` com `limit: 500` — um stream ao vivo de até 500 documentos para exibir um número.

- [ ] **Step 1: Acrescentar o watch de todos os animais**

`AnimalRepository` só tem `watchAnimaisByPropriedade` (linha 138), que filtra por `uidTecnicoPropriedadePath` — o path da PROPRIEDADE, não do técnico. Para contar o rebanho inteiro é preciso um watch sem filtro. O cache local contém apenas os animais do técnico logado, então "todos" já é o escopo certo.

Acrescentar em `lib/data/objectbox/repositories/animal_repository.dart`, junto dos demais watches:

```dart
  /// Stream de todos os animais do aparelho (reatividade local do ObjectBox).
  ///
  /// Sem filtro de propriedade de propósito: o cache local contém apenas os
  /// animais do técnico logado, então isto já é o rebanho dele.
  Stream<List<AnimalEntity>> watchTodos() =>
      box.query().watch(triggerImmediately: true).map((q) => q.find());
```

- [ ] **Step 2: Criar o provider**

Criar `lib/features/animais/application/animais_providers.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/animais/classificacao_animal.dart';

/// Quantidade de animais ativos do técnico, lida do ObjectBox.
///
/// Antes vinha de um `.snapshots()` do Firestore com `limit: 500` — um stream
/// ao vivo de até 500 documentos para exibir um número que já estava local.
final animaisAtivosCountProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(animalRepositoryProvider);
  return repo.watchTodos().map(
        (animais) => animais
            .where((a) =>
                !a.isDeleted &&
                !ehDescarte(a.status) &&
                a.grupoAnimal != 'Sêmens')
            .length,
      );
});
```

O filtro reproduz o que a tela fazia sobre o snapshot do Firestore (`!ehDescarte(e.status) && e.grupoAnimal != 'Sêmens'`), acrescentando `!a.isDeleted` — que no Firestore não era necessário porque documentos soft-deletados já não desciam, mas no ObjectBox continuam presentes.

- [ ] **Step 3: Trocar o card na tela**

Substituir `_buildAnimaisAtivosStatCard` por:

```dart
  /// Card de estatística de animais ativos.
  Widget _buildAnimaisAtivosStatCard(TecnicoEntity tecnicoRecord) {
    final contagem = ref.watch(animaisAtivosCountProvider);
    return contagem.when(
      loading: () => const DashboardStatCardWithStream(
        valueWidget: AppLoadingIndicator(size: 30.0),
        label: 'Animais ativos',
        icon: Icons.pets_rounded,
        accent: AppTokens.secondary,
      ),
      error: (_, __) => const DashboardStatCard(
        value: '—',
        label: 'Animais ativos',
        icon: Icons.pets_rounded,
        accent: AppTokens.secondary,
      ),
      data: (n) => DashboardStatCard(
        value: n.toString(),
        label: 'Animais ativos',
        icon: Icons.pets_rounded,
        accent: AppTokens.secondary,
      ),
    );
  }
```

Remover o import de `AnimaisProdutoresRecord`/`queryAnimaisProdutoresRecord` se ficar sem uso na tela.

- [ ] **Step 4: Verificar**

Run: `flutter analyze lib/features/dashboard lib/features/animais && flutter test`
Expected: sem erros; suíte verde

- [ ] **Step 5: Commit**

```bash
git add lib/features/animais/application lib/features/dashboard lib/data/objectbox/repositories/animal_repository.dart
git commit -m "$(cat <<'EOF'
Conta animais ativos do dashboard pelo ObjectBox

O card usava um snapshots() do Firestore com limit 500 para exibir um numero que
ja estava local. Passa a ler do ObjectBox, sem ida a rede.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 9: Remover o timer de cinco segundos das dezesseis telas

**Files (todas Modify):**
- `lib/features/prontuario/presentation/pages/prontuario_animal_page.dart`
- `lib/features/diagnostico_gestacao/presentation/pages/diagnosticogestacao_page.dart`
- `lib/features/animais/presentation/pages/editar_animal_page.dart`
- `lib/features/animais/presentation/pages/lista_animais_page.dart`
- `lib/features/animais/presentation/pages/cadastrar_novo_animal_page.dart`
- `lib/features/propriedades/presentation/pages/inicio_propriedade_page.dart`
- `lib/features/exame_ginecologico/presentation/pages/exame_ginecologico_page.dart`
- `lib/features/sincronizacao/presentation/pages/importacao_animais_page.dart`
- `lib/features/dashboard/presentation/pages/dashboard_tecnico_page.dart`
- `lib/features/recria/presentation/pages/recriacao_page.dart`
- `lib/features/secas/presentation/pages/secas_page.dart`
- `lib/features/relatorios/presentation/pages/listacompleta_page.dart`
- `lib/features/relatorios/presentation/pages/resumo_rebanho_page.dart`
- `lib/features/produtor/presentation/pages/inicio_propriedade_produtor_page.dart`
- `lib/features/inseminacoes/presentation/pages/lista_inseminacoes_page.dart`
- `lib/features/prenhas/presentation/pages/animais_prenhas_page.dart`
- Delete: `lib/core/services/check_internet_connection.dart`
- Modify: `lib/core/services/index.dart` (remover o export)

**Interfaces:**
- Consumes: `isOnlineProvider` (`core/di/providers.dart:33`)
- Produces: nenhuma API nova

**Contexto:** cada tela roda `InstantTimer.periodic(duration: Duration(seconds: 5))` cujo callback chama `safeSetState(() {})` incondicionalmente — rebuild da árvore inteira a cada cinco segundos, haja mudança ou não. O valor `_respostaNet` é consumido em um único lugar por tela: a cor de um botão.

- [ ] **Step 1: Aplicar a receita, tela por tela**

Para CADA arquivo da lista, nesta ordem:

**a.** Remover do `initState` o bloco do `SchedulerBinding.instance.addPostFrameCallback` que cria o `_instantTimer`. Se o `addPostFrameCallback` tiver outras responsabilidades além do timer, preservar essas e remover só o timer.

**b.** Remover a declaração do campo `_instantTimer` e do campo `_respostaNet`.

**c.** Remover do `dispose` a linha `_instantTimer?.cancel();`.

**d.** Remover os imports que ficarem sem uso: `instant_timer.dart`, `scheduler.dart` (só se nada mais o usar) e o de `actions`/`core/services`.

**e.** Trocar o uso na cor do botão. De:

```dart
_respostaNet! ? Color(0xFFF75E38) : Color(0xFFF2886E),
```

Para:

```dart
(ref.watch(isOnlineProvider).valueOrNull ?? true)
    ? Color(0xFFF75E38)
    : Color(0xFFF2886E),
```

O `?? true` reproduz o padrão da tela, que inicializava `_respostaNet = true`.

**f.** Se a tela ainda for `StatefulWidget`/`StatelessWidget`, converter para `ConsumerStatefulWidget`/`ConsumerWidget` (com `ConsumerState`), seguindo o padrão de `lista_propriedade_page.dart:233`, que já usa `ref.watch(isOnlineProvider)`. Acrescentar `import 'package:flutter_riverpod/flutter_riverpod.dart';`.

**g.** Rodar `flutter analyze <arquivo>` e seguir para a próxima tela só quando estiver limpo.

Casos que exigem atenção: `inicio_propriedade_page.dart` e `inicio_propriedade_produtor_page.dart` têm seis referências a `_respostaNet` cada — uma delas em `inicio_propriedade_page.dart:908` passa o valor como argumento para um widget filho. Esse filho deve receber o booleano derivado de `isOnlineProvider`, ou passar a lê-lo por conta própria se já for um `ConsumerWidget`. Ler o widget de destino antes de decidir.

- [ ] **Step 2: Remover o helper que ficou sem uso**

```bash
git rm lib/core/services/check_internet_connection.dart
```

E remover de `lib/core/services/index.dart` a linha:

```dart
export 'check_internet_connection.dart' show checkInternetConnection;
```

- [ ] **Step 3: Confirmar que não sobrou nenhum uso**

Run: `grep -rn "checkInternetConnection\|_respostaNet\|InstantTimer" lib --include='*.dart'`
Expected: nenhuma ocorrência, exceto a própria definição de `InstantTimer` em `lib/core/ui/instant_timer.dart` se outras telas legítimas ainda a usarem. Se `InstantTimer` ficar totalmente sem uso, removê-lo também.

- [ ] **Step 4: Verificar**

Run: `flutter analyze && flutter test`
Expected: sem erros; suíte verde

- [ ] **Step 5: Commit**

```bash
git add -A lib/features lib/core/services
git commit -m "$(cat <<'EOF'
Remove o timer de 5s que reconstruia 16 telas inteiras

Cada tela rodava InstantTimer.periodic de 5s cujo callback chamava safeSetState
incondicionalmente, reconstruindo a arvore toda houvesse mudanca ou nao. O valor
alimentava um unico lugar: a cor de um botao. Passa a vir de isOnlineProvider,
que so emite em transicao real de conectividade.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 10: Remover o aquecimento de cache do login

**Files:**
- Modify: `lib/features/sincronizacao/data/offline_first_sync_gateway.dart:93-99`

**Interfaces:**
- Consumes: nada
- Produces: nada — `concluirLogin` mantém a assinatura

- [ ] **Step 1: Remover o bloco**

Remover as quatro queries e o comentário:

```dart
    // Aquecimento de cache do Firestore para as telas seguintes.
    await queryPropriedadesRecordOnce(parent: tecnico.reference);
    await queryAcoesRecordOnce(parent: tecnico.reference);
    await queryResumoDaVisitaRecordOnce(
      queryBuilder: (r) => r.where('uidTecnico', isEqualTo: tecnico.reference),
    );
    await queryTipoAcoesRecordOnce();
```

**Preservar** a query de `person` que vem antes: seu resultado decide o destino (`DestinoCompletarPerfil`).

Remover os imports que ficarem sem uso.

- [ ] **Step 2: Verificar**

Run: `flutter analyze lib/features/sincronizacao && flutter test`
Expected: sem erros; suíte verde

- [ ] **Step 3: Commit**

```bash
git add lib/features/sincronizacao/data/offline_first_sync_gateway.dart
git commit -m "$(cat <<'EOF'
Remove o aquecimento de cache do Firestore no login

Quatro queries sequenciais bloqueavam a entrada para aquecer um cache que as
telas seguintes nao usam: elas leem do ObjectBox, que o download completo acabou
de popular.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 11: Reverter a instrumentação de diagnóstico

**Files:**
- Delete: `lib/core/diagnostics/query_tracer.dart`, `lib/core/diagnostics/tracing_navigator_observer.dart`
- Modify: `lib/app/bootstrap.dart` (remover `setLoggingEnabled`)
- Modify: `lib/app/router/nav.dart` (remover o observer e os `name:` das páginas)
- Modify: `lib/data/objectbox/repositories/base_sync_repository.dart`, `lib/data/objectbox/repositories/animal_repository.dart` (remover as chamadas a `QueryTracer`)

**Interfaces:** nenhuma — é remoção pura.

**Contexto:** esta instrumentação foi acrescentada durante o diagnóstico para distinguir leitura local de ida à rede. Cumpriu o papel e não deve ir para produção: o log nativo do Firestore é ruidoso e o tracer acrescenta `debugPrint` em caminho quente.

- [ ] **Step 1: Reverter os arquivos ao estado do commit `163f928`**

```bash
git checkout 163f928 -- lib/app/bootstrap.dart lib/app/router/nav.dart lib/data/objectbox/repositories/base_sync_repository.dart lib/data/objectbox/repositories/animal_repository.dart
rm -rf lib/core/diagnostics
```

**Atenção:** as Tasks 3, 6 e 7 modificaram `base_sync_repository.dart` e `animal_repository.dart`. Esse `checkout` desfaz essas mudanças também. O implementador deve, em vez do checkout cego, remover à mão apenas as linhas de `QueryTracer` e os imports de `core/diagnostics`, preservando o que as tarefas anteriores acrescentaram. Usar `git diff 163f928 -- <arquivo>` para distinguir o que é instrumentação do que é trabalho real.

- [ ] **Step 2: Confirmar que nada referencia a instrumentação**

Run: `grep -rn "QueryTracer\|TracingNavigatorObserver\|setLoggingEnabled\|core/diagnostics" lib --include='*.dart'`
Expected: nenhuma ocorrência

- [ ] **Step 3: Verificar**

Run: `flutter analyze && flutter test`
Expected: sem erros; suíte verde

- [ ] **Step 4: Commit**

```bash
git add -A lib
git commit -m "$(cat <<'EOF'
Remove a instrumentacao temporaria de diagnostico

O tracer de queries, o observer de rotas e o log nativo do Firestore existiam
para distinguir leitura local de ida a rede durante o diagnostico. Cumpriram o
papel; o log nativo e ruidoso e o tracer acrescenta debugPrint em caminho quente.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_012rfxzW1XzT9xdRSHmZ71EE
EOF
)"
```

---

### Task 12: Validação no emulador

**Files:** nenhum — verificação de comportamento.

**Interfaces:** nenhuma.

- [ ] **Step 1: Subir o app com log do Firestore ligado temporariamente**

Reintroduzir `FirebaseFirestore.setLoggingEnabled(true)` em `bootstrap.dart` APENAS localmente, sem commitar. Subir:

```bash
flutter run -d emulator-5554 --debug
```

- [ ] **Step 2: Medir o tráfego de uma sessão**

Capturar o logcat e contar os documentos entregues:

```bash
adb logcat -c
# navegar: login -> sincronizacao -> dashboard -> lista de animais -> voltar
adb logcat -d -v time Firestore:V *:S | grep -c 'document_change'
```

Expected: contagem substancialmente menor que a da sessão de diagnóstico, e **zero** linhas de `👂 Listener iniciado`.

- [ ] **Step 3: Verificar a retomada por etapa**

Com o app já sincronizado, forçar uma falha no meio: desligar a rede do emulador (`adb shell svc data disable && adb shell svc wifi disable`) durante a etapa de animais, religar, e reabrir o app.

Expected no log: `↻ Retomando download: N etapa(s) pendente(s) de 8`, e ausência de novo download das etapas anteriores.

- [ ] **Step 4: Reverter a alteração local do bootstrap**

```bash
git checkout -- lib/app/bootstrap.dart
git status --short
```

Expected: árvore limpa.

---

## Ordem e dependências

```
Task 1 (SyncCheckpoint) ──┬─> Task 3 (laço) ──> Task 4 (count)
Task 2 (exceção de cota) ─┘        │
                                   └─> Task 5 (tela)
Task 6 (lastModified) ─────────────────> Task 7 (pull + desliga listeners)
Task 8 (dashboard)      ─ independente
Task 9 (timer 5s)       ─ independente
Task 10 (aquecimento)   ─ independente
Task 11 (reverter instrumentação) ─ por último, depois de 3/6/7
Task 12 (validação)     ─ por último
```

Tasks 8, 9 e 10 podem ser feitas em qualquer ponto. A Task 11 tem de vir depois de todas as que tocam `base_sync_repository.dart` e `animal_repository.dart`.
