# Progresso de sincronização no login — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tirar o download completo de dentro do botão "Entrar" e mostrá-lo numa tela de sincronização com etapa, porcentagem, contador de registros, ritmo e ETA.

**Architecture:** O `firebase_auth_manager` deixa de sincronizar e volta a só autenticar. A `SyncTechnicianPage` vira `SyncPage` (técnico e produtor), quebrada em controller (orquestra), view (renderiza) e um estimador de ritmo puro. O `OfflineFirstSyncService` passa a paginar animais e gravar em lote, o que destrava a UI thread e permite contadores incrementais.

**Tech Stack:** Flutter, Riverpod (`Notifier`/`NotifierProvider`), ObjectBox, Cloud Firestore, `flutter_test`.

## Global Constraints

- Nome do pacote nos imports de teste: `package:tecmuu/...`
- Testes rodam com `flutter test`. O repositório **não tem `mockito` nem `mocktail`** — todo dublê de teste é uma classe escrita à mão.
- Testes **não podem inicializar ObjectBox nem Firestore**. Toda lógica testada precisa ser pura ou depender de uma interface com fake. Ver `test/repositories/base_sync_repository_test.dart` como referência do padrão.
- Mensagens de commit em português, presente do indicativo, sem prefixo tipo `feat:`, sem acentos (ver `git log`). Toda mensagem termina com:
  `Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`
- Textos de UI em português, com acentos.
- Gradiente da tela de sincronização: `Color(0xFFF75E38)` → `Color(0xFFEC3B5B)`.
- Lottie da tela de sincronização: `assets/jsons/animation_lmv2wwnc.json`.
- Lote de paginação/gravação de animais: **250**.
- Janela da média móvel de ritmo: **3 amostras**.
- ETA suprimido quando o tempo decorrido desde a primeira amostra é **< 2s** ou quando a estimativa resulta em **< 3s**.
- Não usar `print`; o projeto usa `debugPrint`.

---

### Task 1: `SyncRateEstimator` (ritmo e ETA)

Classe pura, sem dependência de Flutter, Firestore ou ObjectBox. É a primeira porque nada depende dela ainda e ela dá o vocabulário de ritmo/ETA para as tarefas seguintes.

**Files:**
- Create: `lib/core/sync/sync_rate_estimator.dart`
- Test: `test/core/sync/sync_rate_estimator_test.dart`

**Interfaces:**
- Consumes: nada.
- Produces:
  ```dart
  class SyncRateEstimator {
    SyncRateEstimator({int janela = 3});
    void registrar(int atual, DateTime em);
    void reiniciar();
    double? get registrosPorSegundo;
    Duration? etaPara(int total);
  }
  ```

- [ ] **Step 1: Write the failing test**

Create `test/core/sync/sync_rate_estimator_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_rate_estimator.dart';

void main() {
  final t0 = DateTime(2026, 1, 1, 12, 0, 0);
  DateTime em(int ms) => t0.add(Duration(milliseconds: ms));

  group('SyncRateEstimator.registrosPorSegundo', () {
    test('sem amostras devolve null', () {
      expect(SyncRateEstimator().registrosPorSegundo, isNull);
    });

    test('uma amostra so nao da ritmo (falta um delta)', () {
      final e = SyncRateEstimator()..registrar(250, em(0));
      expect(e.registrosPorSegundo, isNull);
    });

    test('duas amostras dao o ritmo do intervalo', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(250, em(1000));
      expect(e.registrosPorSegundo, closeTo(250.0, 0.01));
    });

    test('media movel usa apenas as ultimas 3 transicoes', () {
      // Deltas: 100/s, 100/s, 100/s, depois 1000/s tres vezes.
      final e = SyncRateEstimator(janela: 3)
        ..registrar(0, em(0))
        ..registrar(100, em(1000))
        ..registrar(200, em(2000))
        ..registrar(300, em(3000));
      expect(e.registrosPorSegundo, closeTo(100.0, 0.01));

      e
        ..registrar(1300, em(4000))
        ..registrar(2300, em(5000))
        ..registrar(3300, em(6000));
      // As tres transicoes antigas de 100/s ja sairam da janela.
      expect(e.registrosPorSegundo, closeTo(1000.0, 0.01));
    });

    test('poda retem janela + 1 pontos, nao janela', () {
      // Ritmo nao uniforme de proposito: com amostras uniformes, reter 3 ou 4
      // pontos da o mesmo resultado e o teste nao pega o off-by-one.
      final e = SyncRateEstimator(janela: 3)
        ..registrar(0, em(0))
        ..registrar(100, em(1000))
        ..registrar(200, em(2000))
        ..registrar(300, em(3000))
        ..registrar(1300, em(4000));

      // Retendo 4 pontos (o correto): (1300-100)/3s = 400/s.
      // Retendo 3 (poda demais):      (1300-200)/2s = 550/s.
      // Retendo 5 (nao poda):          1300/4s      = 325/s.
      expect(e.registrosPorSegundo, closeTo(400.0, 0.01));
    });

    test('contador que anda para tras nao produz ritmo negativo', () {
      final e = SyncRateEstimator()
        ..registrar(500, em(0))
        ..registrar(200, em(1000));
      expect(e.registrosPorSegundo, isNull);
    });

    test('reiniciar zera o historico', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(250, em(1000))
        ..reiniciar();
      expect(e.registrosPorSegundo, isNull);
    });
  });

  group('SyncRateEstimator.etaPara', () {
    test('sem ritmo devolve null', () {
      expect(SyncRateEstimator().etaPara(3000), isNull);
    });

    test('suprime ETA antes de 2s de amostragem', () {
      // Ritmo existe, mas so 1s decorrido desde a primeira amostra.
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(100, em(1000));
      expect(e.etaPara(3000), isNull);
    });

    test('devolve ETA depois de 2s de amostragem', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(100, em(1000))
        ..registrar(200, em(2000));
      // Faltam 2800 a 100/s = 28s.
      expect(e.etaPara(3000)!.inSeconds, 28);
    });

    test('suprime ETA quando a estimativa cai abaixo de 3s', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(1000, em(1000))
        ..registrar(2000, em(2000));
      // Faltam 100 a 1000/s = 0,1s.
      expect(e.etaPara(2100), isNull);
    });

    test('total ja alcancado devolve null', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(1500, em(1000))
        ..registrar(3000, em(2000));
      expect(e.etaPara(3000), isNull);
    });

    test('total ja ultrapassado devolve null', () {
      final e = SyncRateEstimator()
        ..registrar(0, em(0))
        ..registrar(1500, em(1000))
        ..registrar(3000, em(2000));
      expect(e.etaPara(2500), isNull);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/sync/sync_rate_estimator_test.dart`
Expected: FAIL na compilação — `Error when reading 'lib/core/sync/sync_rate_estimator.dart': No such file or directory`.

- [ ] **Step 3: Write minimal implementation**

Create `lib/core/sync/sync_rate_estimator.dart`:

```dart
/// Calcula ritmo (registros por segundo) e tempo restante estimado a partir de
/// amostras `(quantidade acumulada, instante)`.
///
/// Puro de proposito: o `OfflineFirstSyncService` emite fatos (quantos de
/// quantos) e quem transforma isso em ritmo/ETA e a camada de apresentacao.
/// Sem isso, o servico de sincronizacao acumularia logica de UI.
class SyncRateEstimator {
  SyncRateEstimator({this.janela = 3});

  /// Quantas transicoes entram na media movel. Curta de proposito: sao ~12
  /// lotes num download de 3000 animais, e uma janela maior so produziria
  /// numero depois que o download ja acabou.
  final int janela;

  final List<_Amostra> _amostras = [];

  void registrar(int atual, DateTime em) {
    _amostras.add(_Amostra(atual, em));
    // Guarda uma amostra a mais que a janela: N transicoes exigem N+1 pontos.
    while (_amostras.length > janela + 1) {
      _amostras.removeAt(0);
    }
  }

  void reiniciar() => _amostras.clear();

  double? get registrosPorSegundo {
    if (_amostras.length < 2) return null;

    final primeira = _amostras.first;
    final ultima = _amostras.last;
    final segundos =
        ultima.em.difference(primeira.em).inMicroseconds / Duration.microsecondsPerSecond;
    if (segundos <= 0) return null;

    final delta = ultima.atual - primeira.atual;
    if (delta <= 0) return null;

    return delta / segundos;
  }

  Duration? etaPara(int total) {
    final ritmo = registrosPorSegundo;
    if (ritmo == null || ritmo <= 0) return null;

    // Numero cru logo no comeco pula demais ("47s" virando "4s" um segundo
    // depois destroi mais confianca do que a ausencia do numero).
    final decorrido = _amostras.last.em.difference(_amostras.first.em);
    if (decorrido < const Duration(seconds: 2)) return null;

    final restantes = total - _amostras.last.atual;
    if (restantes <= 0) return null;

    final segundos = restantes / ritmo;
    if (segundos < 3) return null;

    return Duration(milliseconds: (segundos * 1000).round());
  }
}

class _Amostra {
  const _Amostra(this.atual, this.em);
  final int atual;
  final DateTime em;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/sync/sync_rate_estimator_test.dart`
Expected: PASS, 13 testes.

Se `poda retem janela + 1 pontos, nao janela` falhar com 550/s, a poda está removendo um ponto a mais (`> janela` em vez de `> janela + 1`); com 325/s, não está podando.

- [ ] **Step 5: Commit**

```bash
git add lib/core/sync/sync_rate_estimator.dart test/core/sync/sync_rate_estimator_test.dart
git commit -m "$(cat <<'EOF'
Adiciona estimador de ritmo e ETA da sincronizacao

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
EOF
)"
```

---

### Task 2: Progresso global por etapa (função pura)

Converte `(etapa, atual, total)` numa fração 0..1, preservando os **pontos de corte
entre etapas** que `_reportProgress` já usa hoje em
`offline_first_sync_service.dart:149-198`.

Uma diferença é deliberada: hoje o serviço reporta `0.95` ao terminar financeiro e
`1.0` num evento separado de "Download completo finalizado" (linha 198), depois de
gravar metadados de sync. No desenho novo `financeiro` é a última etapa e sua faixa
termina em **1.00** — a conclusão é reportada como essa etapa completa
(`atual: 1, total: 1`). Sem isso a barra nunca alcançaria 100% pelo sistema de
faixas, e o 1.0 teria que vir por fora, furando a invariante "as faixas cobrem 0..1
sem buraco" que o teste de continuidade verifica. O trecho `0.95 → 1.0` do código
atual cobre apenas a gravação de metadados, de milissegundos.

**Files:**
- Create: `lib/core/sync/sync_etapa.dart`
- Test: `test/core/sync/sync_etapa_test.dart`

**Interfaces:**
- Consumes: nada.
- Produces:
  ```dart
  enum SyncEtapa { referencias, usuario, tecnico, produtores, propriedades, animais, acoes, financeiro }
  extension SyncEtapaFaixa on SyncEtapa {
    double get inicio;
    double get fim;
  }
  double progressoGlobal(SyncEtapa etapa, {int? atual, int? total});
  ```

- [ ] **Step 1: Write the failing test**

Create `test/core/sync/sync_etapa_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';

void main() {
  group('faixas das etapas', () {
    test('cobrem 0..1 sem buraco nem sobreposicao', () {
      final etapas = SyncEtapa.values;
      expect(etapas.first.inicio, 0.0);
      expect(etapas.last.fim, 1.0);
      for (var i = 0; i < etapas.length - 1; i++) {
        expect(etapas[i].fim, etapas[i + 1].inicio,
            reason: '${etapas[i]} deve encostar em ${etapas[i + 1]}');
      }
    });

    test('toda faixa avanca', () {
      for (final e in SyncEtapa.values) {
        expect(e.fim, greaterThan(e.inicio), reason: '$e');
      }
    });
  });

  group('progressoGlobal', () {
    test('sem contador devolve o inicio da faixa', () {
      expect(progressoGlobal(SyncEtapa.animais), 0.60);
    });

    test('interpola dentro da faixa da etapa', () {
      // animais vai de 0.60 a 0.70; metade dos animais = 0.65.
      expect(progressoGlobal(SyncEtapa.animais, atual: 1500, total: 3000),
          closeTo(0.65, 0.0001));
    });

    test('contador completo chega ao fim da faixa', () {
      expect(progressoGlobal(SyncEtapa.animais, atual: 3000, total: 3000),
          closeTo(0.70, 0.0001));
    });

    test('total zero nao divide por zero', () {
      expect(progressoGlobal(SyncEtapa.animais, atual: 0, total: 0), 0.60);
    });

    test('atual acima do total nao estoura a faixa', () {
      expect(progressoGlobal(SyncEtapa.animais, atual: 5000, total: 3000),
          closeTo(0.70, 0.0001));
    });

    test('primeira etapa comeca em zero', () {
      expect(progressoGlobal(SyncEtapa.referencias), 0.0);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/sync/sync_etapa_test.dart`
Expected: FAIL — arquivo `lib/core/sync/sync_etapa.dart` inexistente.

- [ ] **Step 3: Write minimal implementation**

Create `lib/core/sync/sync_etapa.dart`:

```dart
/// Etapas do download completo, na ordem em que `performFullDownload` executa.
enum SyncEtapa {
  referencias,
  usuario,
  tecnico,
  produtores,
  propriedades,
  animais,
  acoes,
  financeiro,
}

/// Faixa que cada etapa ocupa na barra global. Os valores reproduzem os que o
/// `performFullDownload` ja reportava, para o ritmo da barra nao mudar.
extension SyncEtapaFaixa on SyncEtapa {
  double get inicio => switch (this) {
        SyncEtapa.referencias => 0.00,
        SyncEtapa.usuario => 0.15,
        SyncEtapa.tecnico => 0.20,
        SyncEtapa.produtores => 0.30,
        SyncEtapa.propriedades => 0.50,
        SyncEtapa.animais => 0.60,
        SyncEtapa.acoes => 0.70,
        SyncEtapa.financeiro => 0.85,
      };

  double get fim => switch (this) {
        SyncEtapa.referencias => 0.15,
        SyncEtapa.usuario => 0.20,
        SyncEtapa.tecnico => 0.30,
        SyncEtapa.produtores => 0.50,
        SyncEtapa.propriedades => 0.60,
        SyncEtapa.animais => 0.70,
        SyncEtapa.acoes => 0.85,
        SyncEtapa.financeiro => 1.00,
      };
}

/// Fracao 0..1 da barra global. Com `atual`/`total`, interpola dentro da faixa
/// da etapa; sem eles, fica no inicio da faixa.
double progressoGlobal(SyncEtapa etapa, {int? atual, int? total}) {
  if (atual == null || total == null || total <= 0) return etapa.inicio;
  final fracao = (atual / total).clamp(0.0, 1.0);
  return etapa.inicio + (etapa.fim - etapa.inicio) * fracao;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/sync/sync_etapa_test.dart`
Expected: PASS, 8 testes.

- [ ] **Step 5: Commit**

```bash
git add lib/core/sync/sync_etapa.dart test/core/sync/sync_etapa_test.dart
git commit -m "$(cat <<'EOF'
Adiciona etapas de sincronizacao e progresso global por faixa

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
EOF
)"
```

---

### Task 3: Reconciliação de animais em lote

O gargalo real. Hoje `_salvarAnimais` (`offline_first_sync_service.dart:537`) faz, por animal, uma query no ObjectBox e um `put()` — 3000 queries e 3000 transações na isolate principal. Esta tarefa extrai a decisão "inserir ou atualizar" para uma função pura e troca o loop por `putMany`.

**Files:**
- Create: `lib/core/sync/reconciliacao_animais.dart`
- Modify: `lib/data/objectbox/offline_first_sync_service.dart:532-553` (`_salvarAnimais`)
- Test: `test/core/sync/reconciliacao_animais_test.dart`

**Interfaces:**
- Consumes: `AnimalEntity` de `package:tecmuu/data/objectbox/entities/index.dart`, com `AnimalEntity.fromFirestore(Map<String, dynamic> data, String docId, String parentPath)` e `void updateFromFirestore(Map<String, dynamic> data)`.
- Produces:
  ```dart
  class DocAnimal {
    const DocAnimal(this.firestoreId, this.data);
    final String firestoreId;
    final Map<String, dynamic> data;
  }
  List<AnimalEntity> reconciliarAnimais({
    required List<DocAnimal> docs,
    required Map<String, AnimalEntity> existentesPorFirestoreId,
    required String parentPath,
  });
  ```

- [ ] **Step 1: Write the failing test**

Create `test/core/sync/reconciliacao_animais_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/reconciliacao_animais.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';

void main() {
  const parentPath = 'tecnico/abc';

  DocAnimal doc(String id, String nome) =>
      DocAnimal(id, <String, dynamic>{'nomeAnimal': nome});

  group('reconciliarAnimais', () {
    test('doc novo vira entidade com id local zerado', () {
      final r = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa')],
        existentesPorFirestoreId: {},
        parentPath: parentPath,
      );

      expect(r, hasLength(1));
      expect(r.single.firestoreId, 'f1');
      expect(r.single.id, 0, reason: 'ObjectBox atribui o id no put');
    });

    test('doc ja existente preserva o id local (nao duplica)', () {
      final existente = AnimalEntity.fromFirestore(
        <String, dynamic>{'nomeAnimal': 'Mimosa'},
        'f1',
        parentPath,
      )..id = 42;

      final r = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa II')],
        existentesPorFirestoreId: {'f1': existente},
        parentPath: parentPath,
      );

      expect(r.single.id, 42);
      expect(r.single.nomeAnimal, 'Mimosa II');
    });

    test('aplicar o mesmo lote duas vezes nao insere de novo', () {
      // Simula o 2o download completo do aparelho, que ja derrubou o download
      // inteiro uma vez por violar o indice unico de firestoreId.
      final primeira = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa'), doc('f2', 'Estrela')],
        existentesPorFirestoreId: {},
        parentPath: parentPath,
      );
      // O put atribuiria ids; simulamos isso.
      primeira[0].id = 1;
      primeira[1].id = 2;

      final segunda = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa'), doc('f2', 'Estrela')],
        existentesPorFirestoreId: {
          for (final e in primeira) e.firestoreId: e,
        },
        parentPath: parentPath,
      );

      expect(segunda.map((e) => e.id), [1, 2]);
    });

    test('lote misto separa novos de existentes', () {
      final existente = AnimalEntity.fromFirestore(
        <String, dynamic>{'nomeAnimal': 'Mimosa'},
        'f1',
        parentPath,
      )..id = 7;

      final r = reconciliarAnimais(
        docs: [doc('f1', 'Mimosa'), doc('f2', 'Nova')],
        existentesPorFirestoreId: {'f1': existente},
        parentPath: parentPath,
      );

      expect(r.map((e) => e.id), [7, 0]);
    });

    test('lote vazio devolve lista vazia', () {
      expect(
        reconciliarAnimais(
          docs: const [],
          existentesPorFirestoreId: {},
          parentPath: parentPath,
        ),
        isEmpty,
      );
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/sync/reconciliacao_animais_test.dart`
Expected: FAIL — arquivo `lib/core/sync/reconciliacao_animais.dart` inexistente.

- [ ] **Step 3: Write minimal implementation**

Create `lib/core/sync/reconciliacao_animais.dart`:

```dart
import '../../data/objectbox/entities/index.dart';

/// Documento do Firestore reduzido ao que a reconciliacao precisa. Existe para
/// a regra ser testavel sem Firestore em runtime.
class DocAnimal {
  const DocAnimal(this.firestoreId, this.data);
  final String firestoreId;
  final Map<String, dynamic> data;
}

/// Decide, para cada doc baixado, se ele atualiza um animal ja existente ou
/// entra como novo, devolvendo a lista pronta para um unico `putMany`.
///
/// Preservar o `id` local do registro existente e o que impede a insercao
/// duplicada que viola o indice unico de `firestoreId` no segundo download
/// completo do aparelho.
List<AnimalEntity> reconciliarAnimais({
  required List<DocAnimal> docs,
  required Map<String, AnimalEntity> existentesPorFirestoreId,
  required String parentPath,
}) {
  final resultado = <AnimalEntity>[];

  for (final doc in docs) {
    final existente = existentesPorFirestoreId[doc.firestoreId];
    if (existente != null) {
      existente.updateFromFirestore(doc.data);
      resultado.add(existente);
    } else {
      resultado.add(
        AnimalEntity.fromFirestore(doc.data, doc.firestoreId, parentPath),
      );
    }
  }

  return resultado;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/sync/reconciliacao_animais_test.dart`
Expected: PASS, 5 testes.

- [ ] **Step 5: Trocar `_salvarAnimais` por gravação em lote**

Em `lib/data/objectbox/offline_first_sync_service.dart`, adicione o import no topo, junto dos outros de `core/sync`:

```dart
import '../../core/sync/reconciliacao_animais.dart';
```

Substitua o método `_salvarAnimais` inteiro (linhas 532-553, do comentário `/// Grava os animais baixados...` até o `}` que fecha o método) por:

```dart
  /// Grava um lote de animais baixados numa unica transacao.
  ///
  /// A versao anterior fazia, por animal, uma query e um `put` — 3000 queries e
  /// 3000 transacoes na isolate principal, o que congelava a UI thread por
  /// dezenas de segundos no primeiro login de um tecnico grande.
  int _salvarAnimais(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String parentPath,
  ) {
    if (docs.isEmpty) return 0;

    final ids = docs.map((d) => d.id).toList();
    final existentes = _objectBox.animalBox
        .query(AnimalEntity_.firestoreId.oneOf(ids))
        .build()
        .find();

    final aGravar = reconciliarAnimais(
      docs: docs.map((d) => DocAnimal(d.id, d.data())).toList(),
      existentesPorFirestoreId: {
        for (final e in existentes) e.firestoreId: e,
      },
      parentPath: parentPath,
    );

    _objectBox.animalBox.putMany(aGravar);
    return docs.length;
  }
```

- [ ] **Step 6: Verify it compiles and nothing regressed**

Run: `flutter analyze lib/data/objectbox/offline_first_sync_service.dart lib/core/sync/reconciliacao_animais.dart`
Expected: sem erros.

Run: `flutter test`
Expected: PASS na suíte inteira.

Se `oneOf` não existir em `QueryStringProperty` na versão do ObjectBox do projeto, o fallback é `_objectBox.animalBox.getAll()` filtrado em memória por um `Set` de ids — mais memória, mesmo resultado. Confirme com `grep -rn "oneOf" ~/.pub-cache/hosted/pub.dev/objectbox-*/lib/src/query/query.dart` antes de trocar.

- [ ] **Step 7: Commit**

```bash
git add lib/core/sync/reconciliacao_animais.dart test/core/sync/reconciliacao_animais_test.dart lib/data/objectbox/offline_first_sync_service.dart
git commit -m "$(cat <<'EOF'
Grava animais baixados em lote em vez de um put por animal

Eram 3000 queries e 3000 transacoes na isolate principal, o que congelava
a UI thread no primeiro login de um tecnico grande.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
EOF
)"
```

---

### Task 4: `SyncProgress` estruturado e paginação dos animais

Faz o serviço emitir etapa e contador, e pagina o download de animais para o contador subir de verdade.

**Files:**
- Modify: `lib/data/objectbox/offline_first_sync_service.dart` — classe `SyncProgress` (`:1422-1433`), `_reportProgress` (`:122-129`), `performFullDownload` (`:137-205`), `_downloadTodosAnimais` (`:506-530`), `_downloadAcoes` (`:563-579`)
- Modify: `lib/data/objectbox/widgets/sync_widgets.dart:51-115` (remover `InitialSyncProgressWidget`)

**Interfaces:**
- Consumes: `SyncEtapa`, `progressoGlobal` da Task 2.
- Produces:
  ```dart
  class SyncProgress {
    const SyncProgress({required this.etapa, required this.message, required this.progress, this.atual, this.total});
    final SyncEtapa etapa;
    final String message;
    final double progress;
    final int? atual;
    final int? total;
  }
  // em OfflineFirstSyncService:
  SyncProgress? get lastProgress;
  ```

- [ ] **Step 1: Reescrever `SyncProgress`**

Em `lib/data/objectbox/offline_first_sync_service.dart`, substitua a classe `SyncProgress` no fim do arquivo (`:1422-1433`) por:

```dart
/// Progresso da sincronizacao. Carrega apenas fatos — etapa e quantos de
/// quantos. Ritmo e ETA sao derivados na apresentacao pelo `SyncRateEstimator`.
class SyncProgress {
  const SyncProgress({
    required this.etapa,
    required this.message,
    required this.progress,
    this.atual,
    this.total,
  });

  final SyncEtapa etapa;
  final String message;
  final double progress;

  /// Preenchidos so nas etapas que sabem contar (animais, acoes).
  final int? atual;
  final int? total;
}
```

O campo `collection`, sempre nulo em todas as chamadas, sai.

Adicione o import no topo do arquivo:

```dart
import '../../core/sync/sync_etapa.dart';
```

- [ ] **Step 2: Reescrever `_reportProgress` e guardar o último progresso**

Substitua `_reportProgress` (`:122-129`) por:

```dart
  SyncProgress? _lastProgress;

  /// Ultimo progresso emitido. A tela de sincronizacao pode montar depois do
  /// primeiro evento; sem isto ela renderizaria vazia ate o proximo lote.
  SyncProgress? get lastProgress => _lastProgress;

  void _reportProgress(
    SyncEtapa etapa,
    String message, {
    int? atual,
    int? total,
  }) {
    final progresso = SyncProgress(
      etapa: etapa,
      message: message,
      progress: progressoGlobal(etapa, atual: atual, total: total),
      atual: atual,
      total: total,
    );
    _lastProgress = progresso;
    _progressController.add(progresso);
    debugPrint(
        '📊 $message (${(progresso.progress * 100).toStringAsFixed(1)}%)');
  }
```

- [ ] **Step 3: Atualizar as chamadas em `performFullDownload`**

Em `performFullDownload` (`:137-205`), troque as dez chamadas de `_reportProgress` pela nova assinatura. As mensagens passam do pretérito ("Animais baixados") para o gerúndio, porque agora são reportadas **antes** da etapa, não depois:

```dart
    _updateStatus(SyncStatus.syncing);
    _reportProgress(SyncEtapa.referencias, 'Tabelas de referência');

    try {
      // 1. Baixa tabelas de referência primeiro (são usadas por outras entidades)
      await _downloadReferenceTables();

      // 2. Sincroniza Person do usuário
      _reportProgress(SyncEtapa.usuario, 'Seus dados');
      await _downloadPerson(userId);

      // 3. Sincroniza Tecnico se existir
      _reportProgress(SyncEtapa.tecnico, 'Dados do técnico');
      final tecnicoRef = await _downloadTecnico(userId);

      // 4. Se for técnico, baixa todos os produtores vinculados
      _reportProgress(SyncEtapa.produtores, 'Produtores');
      if (tecnicoRef != null) {
        await _downloadProdutoresDoTecnico(tecnicoRef);
      } else {
        // Se for produtor, baixa seus próprios dados
        await _downloadProdutor(userId);
      }

      // 5. Baixa todas as propriedades
      _reportProgress(SyncEtapa.propriedades, 'Propriedades');
      await _downloadTodasPropriedades(tecnicoRef, userId);

      // 6. Baixa todos os animais (subcoleção 'animaisProdutores' do técnico)
      await _downloadTodosAnimais(tecnicoRef);

      // 7. Baixa ações e tratamentos
      await _downloadAcoes(tecnicoRef);

      // 8. Baixa dados financeiros e visitas
      _reportProgress(SyncEtapa.financeiro, 'Financeiro e visitas');
      await _downloadFinanceiroEVisitas();
```

E a chamada final, antes de `_updateStatus(SyncStatus.completed)`:

```dart
      _reportProgress(SyncEtapa.financeiro, 'Concluído', atual: 1, total: 1);
```

O `atual: 1, total: 1` não é decorativo: sem contador, `progressoGlobal` devolve o
**início** da faixa da etapa, e a barra terminaria em 85%. Com a fração cheia, ela
interpola até o fim da faixa de `financeiro`, que é 1.0.

`_downloadTodosAnimais` e `_downloadAcoes` não recebem `_reportProgress` aqui: as duas reportam o próprio progresso lote a lote (Steps 4 e 5). Uma chamada antes delas faria a barra saltar para o início da faixa e voltar a interpolar.

- [ ] **Step 4: Paginar `_downloadTodosAnimais`**

Substitua o corpo de `_downloadTodosAnimais` (`:506-530`) por:

```dart
  Future<void> _downloadTodosAnimais(DocumentReference? tecnicoRef) async {
    int totalAnimais = 0;

    if (tecnicoRef != null) {
      final colecao = tecnicoRef.collection('animaisProdutores');
      final total = (await colecao.count().get()).count ?? 0;
      totalAnimais = await _baixarAnimaisPaginado(
        colecao,
        tecnicoRef.path,
        total,
        0,
      );
    } else {
      // Produtor: chega no rebanho pelo caminho das propriedades dele, e
      // filtrando por propriedade — enxerga o dele, nao o rebanho do tecnico.
      final alvos = alvosAnimaisProdutor(_objectBox.propriedadeBox.getAll());

      final consultas = {
        for (final alvo in alvos)
          alvo: _firestore
              .doc(alvo.tecnicoPath)
              .collection('animaisProdutores')
              .where('uidTecnicoPropriedade',
                  isEqualTo: _firestore.doc(alvo.propriedadePath)),
      };

      var total = 0;
      for (final consulta in consultas.values) {
        total += (await consulta.count().get()).count ?? 0;
      }

      for (final entrada in consultas.entries) {
        try {
          totalAnimais = await _baixarAnimaisPaginado(
            entrada.value,
            entrada.key.tecnicoPath,
            total,
            totalAnimais,
          );
        } catch (e) {
          debugPrint(
              '⚠️ Erro ao baixar animais de ${entrada.key.propriedadePath}: $e');
        }
      }
    }

    debugPrint('🐄 $totalAnimais animal(is) baixado(s)');
  }

  /// Tamanho do lote de download e gravacao. 250 e nao 500 por causa do ritmo:
  /// cada lote e uma amostra para o estimador, e com 500 haveria so 6 amostras
  /// em 3000 animais — o ritmo mal apareceria antes de terminar.
  static const int _loteDownload = 250;

  /// Baixa animais em paginas, reportando progresso a cada lote. Devolve o
  /// acumulado atualizado.
  Future<int> _baixarAnimaisPaginado(
    Query<Map<String, dynamic>> consulta,
    String parentPath,
    int total,
    int acumulado,
  ) async {
    DocumentSnapshot? ultimo;

    while (true) {
      var pagina = consulta.orderBy(FieldPath.documentId).limit(_loteDownload);
      if (ultimo != null) pagina = pagina.startAfterDocument(ultimo);

      final snapshot = await pagina.get();
      if (snapshot.docs.isEmpty) break;

      acumulado += _salvarAnimais(snapshot.docs, parentPath);
      ultimo = snapshot.docs.last;

      _reportProgress(
        SyncEtapa.animais,
        'Animais',
        atual: acumulado,
        total: total,
      );

      // Devolve a isolate principal ao event loop para a UI respirar entre
      // lotes; sem isso a barra de progresso nao anima.
      await Future<void>.delayed(Duration.zero);

      if (snapshot.docs.length < _loteDownload) break;
    }

    return acumulado;
  }
```

- [ ] **Step 5: Dar o mesmo tratamento a `_downloadAcoes`**

`_downloadAcoes` (`:563`) tem o mesmo padrão de `put` por documento que
`_salvarAnimais` tinha, e a checklist da tela promete contador nessa etapa.
Substitua o bloco das ações do técnico dentro de `_downloadAcoes` (o
`if (tecnicoRef != null) { ... }`, linhas 567-579) por:

```dart
    if (tecnicoRef != null) {
      try {
        final colecao = tecnicoRef.collection('acoes');
        final total = (await colecao.count().get()).count ?? 0;
        DocumentSnapshot? ultimo;

        while (true) {
          var pagina = colecao.orderBy(FieldPath.documentId).limit(_loteDownload);
          if (ultimo != null) pagina = pagina.startAfterDocument(ultimo);

          final snapshot = await pagina.get();
          if (snapshot.docs.isEmpty) break;

          _objectBox.acaoBox.putMany([
            for (final doc in snapshot.docs)
              AcaoEntity.fromFirestore(doc.data(), doc.id, tecnicoRef.path),
          ]);

          totalAcoes += snapshot.docs.length;
          ultimo = snapshot.docs.last;

          _reportProgress(
            SyncEtapa.acoes,
            'Ações e tratamentos',
            atual: totalAcoes,
            total: total,
          );
          await Future<void>.delayed(Duration.zero);

          if (snapshot.docs.length < _loteDownload) break;
        }
      } catch (e) {
        debugPrint('⚠️ Erro ao baixar ações: $e');
      }
    }
```

Diferente dos animais, aqui não há reconciliação por `firestoreId`: o código
original já inseria direto com `AcaoEntity.fromFirestore` sem procurar existente,
e mudar isso está fora do escopo desta tarefa. A mudança é só o `putMany` no lugar
do `put` em loop, mais o progresso.

Confirme que não sobrou nenhum `_reportProgress(SyncEtapa.acoes, ...)` **antes** da
chamada `await _downloadAcoes(tecnicoRef)` em `performFullDownload`: a etapa reporta
o próprio progresso, e uma chamada extra faria a barra saltar para o início da faixa
e voltar a interpolar.

- [ ] **Step 6: Remover o `InitialSyncProgressWidget` morto**

Em `lib/data/objectbox/widgets/sync_widgets.dart`, apague a classe `InitialSyncProgressWidget` inteira (`:50-115`, do comentário `/// Widget de progresso de sincronização inicial` até o `}` que a fecha). Ela nunca foi usada por nenhum arquivo e não compila mais com o novo `SyncProgress`. A `SyncProgressView` da Task 7 a substitui.

- [ ] **Step 7: Verify**

Run: `flutter analyze lib/data/objectbox/ lib/core/sync/`
Expected: sem erros.

Run: `flutter test`
Expected: PASS.

Se `flutter analyze` acusar uso de `SyncProgress.collection` em algum lugar, é código que o grep inicial não pegou — remova o uso, o campo saiu de propósito.

- [ ] **Step 8: Commit**

```bash
git add lib/data/objectbox/offline_first_sync_service.dart lib/data/objectbox/widgets/sync_widgets.dart
git commit -m "$(cat <<'EOF'
Pagina o download de animais e reporta progresso por etapa

SyncProgress passa a carregar etapa e contador, e os animais descem em
lotes de 250 para o contador subir durante o download.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
EOF
)"
```

---

### Task 5: Sinalizar offline e parar de engolir erros

Hoje `performFullDownload` retorna em silêncio quando está offline (`:142-146`) e `onUserLogin` captura toda exceção e só loga (`objectbox_auth_helper.dart:97-100`). Juntos, fazem um download que não aconteceu parecer sucesso.

**Files:**
- Create: `lib/core/sync/sync_exceptions.dart`
- Modify: `lib/data/objectbox/offline_first_sync_service.dart:137-150` (`performFullDownload`)
- Modify: `lib/data/objectbox/objectbox_auth_helper.dart:58-101` (`onUserLogin`)
- Test: `test/core/sync/sync_exceptions_test.dart`

**Interfaces:**
- Produces:
  ```dart
  class SyncOfflineException implements Exception {
    const SyncOfflineException();
  }
  class SyncFalhaException implements Exception {
    const SyncFalhaException(this.etapa, this.causa);
    final SyncEtapa? etapa;
    final Object causa;
    String get mensagem;
  }
  ```

- [ ] **Step 1: Write the failing test**

Create `test/core/sync/sync_exceptions_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';
import 'package:tecmuu/core/sync/sync_exceptions.dart';

void main() {
  test('SyncFalhaException expoe a etapa que quebrou', () {
    const e = SyncFalhaException(SyncEtapa.animais, 'timeout');
    expect(e.etapa, SyncEtapa.animais);
    expect(e.mensagem, contains('timeout'));
  });

  test('SyncFalhaException aceita etapa desconhecida', () {
    const e = SyncFalhaException(null, 'boom');
    expect(e.etapa, isNull);
    expect(e.mensagem, contains('boom'));
  });

  test('SyncOfflineException e um Exception', () {
    expect(const SyncOfflineException(), isA<Exception>());
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/sync/sync_exceptions_test.dart`
Expected: FAIL — arquivo inexistente.

- [ ] **Step 3: Write minimal implementation**

Create `lib/core/sync/sync_exceptions.dart`:

```dart
import 'sync_etapa.dart';

/// Download completo pedido sem conexao. Distinta de uma falha: nao ha nada a
/// tentar consertar alem de reconectar, e a tela oferece so "Tentar novamente".
class SyncOfflineException implements Exception {
  const SyncOfflineException();

  @override
  String toString() => 'SyncOfflineException';
}

/// Uma etapa do download completo quebrou. Carrega a etapa para a tela poder
/// dizer o que falhou em vez de mostrar um erro generico.
class SyncFalhaException implements Exception {
  const SyncFalhaException(this.etapa, this.causa);

  final SyncEtapa? etapa;
  final Object causa;

  String get mensagem => causa.toString();

  @override
  String toString() => 'SyncFalhaException($etapa): $mensagem';
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/sync/sync_exceptions_test.dart`
Expected: PASS, 3 testes.

- [ ] **Step 5: Fazer `performFullDownload` lançar em vez de silenciar**

Em `lib/data/objectbox/offline_first_sync_service.dart`, adicione o import:

```dart
import '../../core/sync/sync_exceptions.dart';
```

Troque o bloco offline no início de `performFullDownload` (`:142-146`):

```dart
    if (!_isOnline) {
      debugPrint('📴 Offline - download adiado');
      _updateStatus(SyncStatus.offline);
      throw const SyncOfflineException();
    }
```

E o `catch` no fim do método (`:200-204`):

```dart
    } on SyncOfflineException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Erro no download completo: $e');
      _updateStatus(SyncStatus.error);
      throw SyncFalhaException(_lastProgress?.etapa, e);
    }
```

- [ ] **Step 6: Fazer `onUserLogin` propagar**

Em `lib/data/objectbox/objectbox_auth_helper.dart`, remova o `try`/`catch` de `onUserLogin` (`:71-100`), mantendo o corpo. O método fica:

```dart
  /// Sincroniza dados do usuário após login.
  ///
  /// Propaga [SyncOfflineException] e [SyncFalhaException]: quem chama e a tela
  /// de sincronizacao, que sabe mostrar erro e oferecer nova tentativa. A versao
  /// anterior engolia a excecao aqui, e um download que nao aconteceu chegava na
  /// UI como sucesso.
  static Future<void> onUserLogin(User user) async {
    if (kIsWeb) return;

    if (!ObjectBoxService.isInitialized) {
      await ObjectBoxService.initialize();
    }

    if (!OfflineFirstSyncService.isInitialized) {
      await OfflineFirstSyncService.initialize();
    }

    final syncService = OfflineFirstSyncService.instance;

    // Faz o download completo na primeira sincronização OU quando o cache de
    // animais está vazio (auto-recuperação de instalações cujo sync anterior
    // baixou do path errado e ficou sem animais).
    final semAnimaisLocais = ObjectBoxService.instance.animalBox.count() == 0;
    if (syncService.needsInitialSync() || semAnimaisLocais) {
      debugPrint('📥 Baixando todos os dados...');
      await syncService.performFullDownload(userId: user.uid);
    } else {
      // Sincroniza apenas alterações pendentes
      debugPrint('🔄 Sincronizando alterações pendentes...');
      await syncService.syncPendingChangesToFirestore();
    }

    // Auto-recuperação (uma vez por instalação): quem já tinha sincronizado
    // antes da correção ficou com as propriedades no path do produtor e nunca
    // re-baixa por conta própria. Re-baixa só as propriedades.
    await syncService.repararPathPropriedades(user.uid);

    debugPrint('✅ Sincronização após login concluída');

    // Manutenção: remove soft-deletes já sincronizados (Fase 1.5).
    final purged = purgeAllSyncedSoftDeletes();
    if (purged > 0) {
      debugPrint('🧹 $purged registro(s) soft-deleted purgado(s)');
    }
  }
```

- [ ] **Step 7: Verify**

Run: `flutter analyze lib/data/objectbox/ lib/core/sync/`
Expected: sem erros.

Run: `flutter test`
Expected: PASS.

- [ ] **Step 8: Commit**

```bash
git add lib/core/sync/sync_exceptions.dart test/core/sync/sync_exceptions_test.dart lib/data/objectbox/offline_first_sync_service.dart lib/data/objectbox/objectbox_auth_helper.dart
git commit -m "$(cat <<'EOF'
Faz o download completo sinalizar offline e falha em vez de silenciar

Offline e erro chegavam na UI como sucesso, mandando o tecnico para um
dashboard vazio como se estivesse tudo certo.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
EOF
)"
```

---

### Task 6: Estados e destino da tela de sincronização

Tipos puros que descrevem o que a tela mostra e para onde ela vai. Sem lógica, mas é o contrato que a Task 7 (view) e a Task 8 (controller) compartilham.

**Files:**
- Create: `lib/features/sincronizacao/domain/sync_state.dart`
- Test: `test/features/sincronizacao/sync_state_test.dart`

**Interfaces:**
- Consumes: `SyncEtapa` (Task 2).
- Produces:
  ```dart
  enum SyncPapel { tecnico, produtor }
  enum SyncErroTipo { falhaDownload, semConexao }

  sealed class SyncDestino {}
  class DestinoDashboardTecnico extends SyncDestino {}
  class DestinoInicioPropriedadeProdutor extends SyncDestino { final Object? propriedade; }
  class DestinoCompletarPerfil extends SyncDestino {}

  sealed class SyncState {}
  class SyncPreparando extends SyncState {}
  class SyncBaixando extends SyncState {
    final SyncEtapa etapa; final String rotulo; final double progresso;
    final int? atual; final int? total; final double? ritmo; final Duration? eta;
  }
  class SyncErro extends SyncState { final SyncErroTipo tipo; final SyncEtapa? etapa; final String mensagem; }
  class SyncConcluido extends SyncState { final SyncDestino destino; }
  ```

- [ ] **Step 1: Write the failing test**

Create `test/features/sincronizacao/sync_state_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_state.dart';

void main() {
  group('SyncBaixando', () {
    test('mostra contador so quando tem total', () {
      final semTotal = SyncBaixando(
        etapa: SyncEtapa.referencias,
        rotulo: 'Tabelas de referência',
        progresso: 0.0,
      );
      expect(semTotal.temContador, false);

      final comTotal = SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.65,
        atual: 1240,
        total: 3000,
      );
      expect(comTotal.temContador, true);
    });

    test('total zero nao conta como contador', () {
      final e = SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.6,
        atual: 0,
        total: 0,
      );
      expect(e.temContador, false);
    });
  });

  group('SyncErro', () {
    test('semConexao nao oferece continuar com dados parciais', () {
      final e = SyncErro(
        tipo: SyncErroTipo.semConexao,
        mensagem: 'Sem conexão',
      );
      expect(e.podeContinuarAssimMesmo, false);
      expect(e.etapa, isNull);
    });

    test('falhaDownload oferece continuar com o que baixou', () {
      final e = SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        etapa: SyncEtapa.animais,
        mensagem: 'timeout',
      );
      expect(e.podeContinuarAssimMesmo, true);
      expect(e.etapa, SyncEtapa.animais);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/sincronizacao/sync_state_test.dart`
Expected: FAIL — arquivo inexistente.

- [ ] **Step 3: Write minimal implementation**

Create `lib/features/sincronizacao/domain/sync_state.dart`:

```dart
import '../../../core/sync/sync_etapa.dart';

/// Quem esta entrando. Vem por parametro de rota, nao e deduzido da existencia
/// do TecnicoRecord: deduzir confundiria "produtor" com "tecnico sem perfil
/// completo", que sao destinos diferentes.
enum SyncPapel { tecnico, produtor }

enum SyncErroTipo {
  /// Uma etapa quebrou. Ha dados parciais gravados.
  falhaDownload,

  /// Offline e sem nada baixado ainda. Nao ha dado parcial com que continuar.
  semConexao,
}

/// Para onde ir quando a sincronizacao terminar.
sealed class SyncDestino {
  const SyncDestino();
}

class DestinoDashboardTecnico extends SyncDestino {
  const DestinoDashboardTecnico();
}

class DestinoInicioPropriedadeProdutor extends SyncDestino {
  const DestinoInicioPropriedadeProdutor(this.propriedade);

  /// `PropriedadesRecord?`. Tipado como Object? para o dominio nao depender do
  /// schema do Firestore, o que quebraria os testes puros.
  final Object? propriedade;
}

class DestinoCompletarPerfil extends SyncDestino {
  const DestinoCompletarPerfil();
}

sealed class SyncState {
  const SyncState();
}

class SyncPreparando extends SyncState {
  const SyncPreparando();
}

class SyncBaixando extends SyncState {
  const SyncBaixando({
    required this.etapa,
    required this.rotulo,
    required this.progresso,
    this.atual,
    this.total,
    this.ritmo,
    this.eta,
  });

  final SyncEtapa etapa;
  final String rotulo;
  final double progresso;
  final int? atual;
  final int? total;

  /// Registros por segundo. Nulo enquanto nao ha amostras suficientes.
  final double? ritmo;
  final Duration? eta;

  /// Etapas curtas (um documento) nao tem contador — mostrar numero nelas so
  /// produziria um valor piscando.
  bool get temContador => atual != null && total != null && total! > 0;
}

class SyncErro extends SyncState {
  const SyncErro({
    required this.tipo,
    required this.mensagem,
    this.etapa,
  });

  final SyncErroTipo tipo;
  final SyncEtapa? etapa;
  final String mensagem;

  bool get podeContinuarAssimMesmo => tipo == SyncErroTipo.falhaDownload;
}

class SyncConcluido extends SyncState {
  const SyncConcluido(this.destino);
  final SyncDestino destino;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/sincronizacao/sync_state_test.dart`
Expected: PASS, 4 testes.

- [ ] **Step 5: Commit**

```bash
git add lib/features/sincronizacao/domain/sync_state.dart test/features/sincronizacao/sync_state_test.dart
git commit -m "$(cat <<'EOF'
Adiciona estados e destinos da tela de sincronizacao

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
EOF
)"
```

---

### Task 7: `SyncPageController`

O coração da tarefa. Orquestra download → perfil → destino, traduzindo progresso em estado. Depende de uma porta estreita (`SyncGateway`) para ser testável sem Firestore nem ObjectBox.

**Files:**
- Create: `lib/features/sincronizacao/domain/sync_gateway.dart`
- Create: `lib/features/sincronizacao/presentation/controllers/sync_page_controller.dart`
- Test: `test/features/sincronizacao/sync_page_controller_test.dart`

**Interfaces:**
- Consumes: `SyncState`, `SyncPapel`, `SyncDestino`, `SyncErroTipo` (Task 6); `SyncProgress`, `lastProgress` (Task 4); `SyncOfflineException`, `SyncFalhaException` (Task 5); `SyncRateEstimator` (Task 1); `progressoGlobal`, `SyncEtapa` (Task 2).
- Produces:
  ```dart
  abstract class SyncGateway {
    bool get temDadosLocais;
    Stream<SyncProgress> get progressStream;
    SyncProgress? get ultimoProgresso;
    Future<void> baixarTudo();
    Future<SyncDestino> concluirLogin(SyncPapel papel);
  }
  final syncGatewayProvider = Provider<SyncGateway>((ref) => throw UnimplementedError());
  class SyncPageController extends Notifier<SyncState> {
    Future<void> iniciar(SyncPapel papel);
    Future<void> tentarNovamente();
    void continuarAssimMesmo();
  }
  final syncPageControllerProvider = NotifierProvider<SyncPageController, SyncState>(SyncPageController.new);
  ```

- [ ] **Step 1: Criar a porta**

Create `lib/features/sincronizacao/domain/sync_gateway.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/objectbox/offline_first_sync_service.dart';
import 'sync_state.dart';

/// Porta estreita entre a tela de sincronizacao e a infraestrutura.
///
/// Existe para o controller ser testavel: o projeto nao usa mockito, e nem
/// ObjectBox nem Firestore podem ser inicializados em teste. O fake do teste
/// implementa estes cinco membros e nada mais.
abstract class SyncGateway {
  /// Se ja ha animais no cache local. Decide se ficar offline e fatal ou nao.
  bool get temDadosLocais;

  Stream<SyncProgress> get progressStream;

  /// Ultimo progresso emitido, para a tela nao renderizar vazia se montar
  /// depois do primeiro lote.
  SyncProgress? get ultimoProgresso;

  /// Download completo (ou sincronizacao de pendencias, se ja houver dados).
  /// Lanca `SyncOfflineException` ou `SyncFalhaException`.
  Future<void> baixarTudo();

  /// Busca person/tecnico, liga os listeners remotos, aquece caches e resolve
  /// para onde navegar.
  Future<SyncDestino> concluirLogin(SyncPapel papel);
}

/// Sobrescrito no `main`/`app` com a implementacao real e, no teste, com um fake.
final syncGatewayProvider = Provider<SyncGateway>(
  (ref) => throw UnimplementedError('syncGatewayProvider precisa de override'),
);
```

- [ ] **Step 2: Write the failing test**

Create `test/features/sincronizacao/sync_page_controller_test.dart`:

```dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';
import 'package:tecmuu/core/sync/sync_exceptions.dart';
import 'package:tecmuu/data/objectbox/offline_first_sync_service.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_gateway.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_state.dart';
import 'package:tecmuu/features/sincronizacao/presentation/controllers/sync_page_controller.dart';

/// Dublê escrito à mão: o projeto não usa mockito.
class FakeSyncGateway implements SyncGateway {
  FakeSyncGateway({
    this.temDadosLocais = false,
    this.erroAoBaixar,
    this.destino = const DestinoDashboardTecnico(),
  });

  @override
  bool temDadosLocais;

  Object? erroAoBaixar;
  SyncDestino destino;

  int vezesQueBaixou = 0;
  int vezesQueConcluiu = 0;

  final _controller = StreamController<SyncProgress>.broadcast();

  @override
  Stream<SyncProgress> get progressStream => _controller.stream;

  @override
  SyncProgress? ultimoProgresso;

  void emitir(SyncProgress p) {
    ultimoProgresso = p;
    _controller.add(p);
  }

  @override
  Future<void> baixarTudo() async {
    vezesQueBaixou++;
    if (erroAoBaixar != null) throw erroAoBaixar!;
  }

  @override
  Future<SyncDestino> concluirLogin(SyncPapel papel) async {
    vezesQueConcluiu++;
    return destino;
  }

  void dispose() => _controller.close();
}

ProviderContainer containerCom(FakeSyncGateway fake) {
  final c = ProviderContainer(
    overrides: [syncGatewayProvider.overrideWithValue(fake)],
  );
  addTearDown(c.dispose);
  addTearDown(fake.dispose);
  return c;
}

void main() {
  group('caminho feliz', () {
    test('começa em Preparando', () {
      final fake = FakeSyncGateway();
      final c = containerCom(fake);
      expect(c.read(syncPageControllerProvider), isA<SyncPreparando>());
    });

    test('conclui com o destino do gateway', () async {
      final fake = FakeSyncGateway();
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(SyncPapel.tecnico);

      final estado = c.read(syncPageControllerProvider);
      expect(estado, isA<SyncConcluido>());
      expect((estado as SyncConcluido).destino, isA<DestinoDashboardTecnico>());
      expect(fake.vezesQueBaixou, 1);
      expect(fake.vezesQueConcluiu, 1);
    });

    test('progresso do gateway vira SyncBaixando com contador', () async {
      final fake = FakeSyncGateway();
      final c = containerCom(fake);

      final estados = <SyncState>[];
      c.listen(syncPageControllerProvider, (_, novo) => estados.add(novo));

      final futuro = c
          .read(syncPageControllerProvider.notifier)
          .iniciar(SyncPapel.tecnico);

      fake.emitir(const SyncProgress(
        etapa: SyncEtapa.animais,
        message: 'Animais',
        progress: 0.65,
        atual: 1240,
        total: 3000,
      ));
      await Future<void>.delayed(Duration.zero);
      await futuro;

      final baixando = estados.whereType<SyncBaixando>().toList();
      expect(baixando, isNotEmpty);
      expect(baixando.last.atual, 1240);
      expect(baixando.last.total, 3000);
      expect(baixando.last.temContador, true);
    });
  });

  group('erro', () {
    test('falha no download vira SyncErro com a etapa', () async {
      final fake = FakeSyncGateway(
        erroAoBaixar: const SyncFalhaException(SyncEtapa.animais, 'timeout'),
      );
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(SyncPapel.tecnico);

      final estado = c.read(syncPageControllerProvider);
      expect(estado, isA<SyncErro>());
      final erro = estado as SyncErro;
      expect(erro.tipo, SyncErroTipo.falhaDownload);
      expect(erro.etapa, SyncEtapa.animais);
      expect(erro.podeContinuarAssimMesmo, true);
    });

    test('tentarNovamente refaz o download', () async {
      final fake = FakeSyncGateway(
        erroAoBaixar: const SyncFalhaException(SyncEtapa.animais, 'timeout'),
      );
      final c = containerCom(fake);
      final notifier = c.read(syncPageControllerProvider.notifier);

      await notifier.iniciar(SyncPapel.tecnico);
      expect(c.read(syncPageControllerProvider), isA<SyncErro>());

      fake.erroAoBaixar = null;
      await notifier.tentarNovamente();

      expect(c.read(syncPageControllerProvider), isA<SyncConcluido>());
      expect(fake.vezesQueBaixou, 2);
    });

    test('continuarAssimMesmo conclui com o destino resolvido', () async {
      final fake = FakeSyncGateway(
        erroAoBaixar: const SyncFalhaException(SyncEtapa.animais, 'timeout'),
      );
      final c = containerCom(fake);
      final notifier = c.read(syncPageControllerProvider.notifier);

      await notifier.iniciar(SyncPapel.tecnico);
      await notifier.continuarAssimMesmo();

      expect(c.read(syncPageControllerProvider), isA<SyncConcluido>());
    });
  });

  group('offline', () {
    test('offline sem dados locais vira erro de conexao', () async {
      final fake = FakeSyncGateway(
        temDadosLocais: false,
        erroAoBaixar: const SyncOfflineException(),
      );
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(SyncPapel.tecnico);

      final estado = c.read(syncPageControllerProvider) as SyncErro;
      expect(estado.tipo, SyncErroTipo.semConexao);
      expect(estado.podeContinuarAssimMesmo, false);
    });

    test('offline com dados locais conclui direto', () async {
      final fake = FakeSyncGateway(
        temDadosLocais: true,
        erroAoBaixar: const SyncOfflineException(),
      );
      final c = containerCom(fake);

      await c.read(syncPageControllerProvider.notifier).iniciar(SyncPapel.produtor);

      expect(c.read(syncPageControllerProvider), isA<SyncConcluido>());
      expect(fake.vezesQueConcluiu, 1);
    });
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/features/sincronizacao/sync_page_controller_test.dart`
Expected: FAIL — `sync_page_controller.dart` inexistente.

- [ ] **Step 4: Write minimal implementation**

Create `lib/features/sincronizacao/presentation/controllers/sync_page_controller.dart`:

```dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sync/sync_etapa.dart';
import '../../../../core/sync/sync_exceptions.dart';
import '../../../../core/sync/sync_rate_estimator.dart';
import '../../../../data/objectbox/offline_first_sync_service.dart';
import '../../domain/sync_gateway.dart';
import '../../domain/sync_state.dart';

/// Orquestra a tela de sincronizacao: download completo, resolucao de perfil e
/// destino. Nao conhece GoRouter nem widgets — devolve um [SyncDestino] e a
/// page traduz para navegacao.
class SyncPageController extends Notifier<SyncState> {
  StreamSubscription<SyncProgress>? _inscricao;
  final SyncRateEstimator _estimador = SyncRateEstimator();
  SyncPapel _papel = SyncPapel.tecnico;

  @override
  SyncState build() {
    ref.onDispose(() => _inscricao?.cancel());
    return const SyncPreparando();
  }

  SyncGateway get _gateway => ref.read(syncGatewayProvider);

  Future<void> iniciar(SyncPapel papel) async {
    _papel = papel;
    await _executar();
  }

  Future<void> tentarNovamente() => _executar();

  Future<void> _executar() async {
    state = const SyncPreparando();
    _estimador.reiniciar();

    await _inscricao?.cancel();
    _inscricao = _gateway.progressStream.listen(_aoProgredir);

    final ultimo = _gateway.ultimoProgresso;
    if (ultimo != null) _aoProgredir(ultimo);

    try {
      await _gateway.baixarTudo();
    } on SyncOfflineException {
      // Offline com dados locais e o caso normal do tecnico em campo: segue.
      // Sem dados locais, entrar num app vazio pareceria perda de dados.
      if (!_gateway.temDadosLocais) {
        state = const SyncErro(
          tipo: SyncErroTipo.semConexao,
          mensagem: 'Sem conexão com a internet.',
        );
        return;
      }
    } on SyncFalhaException catch (e) {
      state = SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        etapa: e.etapa,
        mensagem: e.mensagem,
      );
      return;
    } catch (e) {
      state = SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        mensagem: e.toString(),
      );
      return;
    }

    await _concluir();
  }

  /// Vai ao destino com os dados parciais. Seguro porque `initial_download` so
  /// e marcado completo no fim do download: o proximo login rebaixa tudo.
  Future<void> continuarAssimMesmo() => _concluir();

  Future<void> _concluir() async {
    try {
      final destino = await _gateway.concluirLogin(_papel);
      state = SyncConcluido(destino);
    } catch (e) {
      state = SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        mensagem: e.toString(),
      );
    }
  }

  void _aoProgredir(SyncProgress p) {
    if (p.atual != null && p.total != null) {
      _estimador.registrar(p.atual!, DateTime.now());
    }

    state = SyncBaixando(
      etapa: p.etapa,
      rotulo: p.message,
      progresso: p.progress,
      atual: p.atual,
      total: p.total,
      ritmo: _estimador.registrosPorSegundo,
      eta: p.total == null ? null : _estimador.etaPara(p.total!),
    );
  }
}

final syncPageControllerProvider =
    NotifierProvider<SyncPageController, SyncState>(SyncPageController.new);
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/sincronizacao/sync_page_controller_test.dart`
Expected: PASS, 8 testes.

Se `progresso do gateway vira SyncBaixando com contador` falhar por não capturar nenhum `SyncBaixando`, o `emitir` está sendo chamado antes de `_executar` assinar o stream — mova o `fake.emitir(...)` para depois de um `await Future<void>.delayed(Duration.zero)`.

- [ ] **Step 6: Commit**

```bash
git add lib/features/sincronizacao/domain/sync_gateway.dart lib/features/sincronizacao/presentation/controllers/sync_page_controller.dart test/features/sincronizacao/sync_page_controller_test.dart
git commit -m "$(cat <<'EOF'
Adiciona controller da tela de sincronizacao

Orquestra download, perfil e destino atras de uma porta estreita, para
ser testavel sem ObjectBox nem Firestore.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
EOF
)"
```

---

### Task 8: `SyncProgressView`

Renderiza o estado. Sem lógica além de formatação.

**Files:**
- Create: `lib/features/sincronizacao/presentation/widgets/sync_progress_view.dart`
- Test: `test/features/sincronizacao/sync_progress_view_test.dart`

**Interfaces:**
- Consumes: `SyncState` e subclasses (Task 6), `SyncEtapa` (Task 2).
- Produces:
  ```dart
  class SyncProgressView extends StatelessWidget {
    const SyncProgressView({super.key, required this.estado, required this.onTentarNovamente, required this.onContinuarAssimMesmo});
    final SyncState estado;
    final VoidCallback onTentarNovamente;
    final VoidCallback onContinuarAssimMesmo;
  }
  String rotuloLinha(SyncEtapa etapa);
  const List<SyncEtapa> linhasVisiveis;
  ```

- [ ] **Step 1: Write the failing test**

Create `test/features/sincronizacao/sync_progress_view_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/sync_etapa.dart';
import 'package:tecmuu/features/sincronizacao/domain/sync_state.dart';
import 'package:tecmuu/features/sincronizacao/presentation/widgets/sync_progress_view.dart';

void main() {
  Future<void> montar(WidgetTester tester, SyncState estado) {
    return tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SyncProgressView(
          estado: estado,
          onTentarNovamente: () {},
          onContinuarAssimMesmo: () {},
        ),
      ),
    ));
  }

  testWidgets('mostra contador quando a etapa tem total', (tester) async {
    await montar(
      tester,
      const SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.65,
        atual: 1240,
        total: 3000,
      ),
    );

    expect(find.textContaining('1.240 de 3.000'), findsOneWidget);
  });

  testWidgets('esconde ritmo e ETA quando nao ha total', (tester) async {
    await montar(
      tester,
      const SyncBaixando(
        etapa: SyncEtapa.referencias,
        rotulo: 'Tabelas de referência',
        progresso: 0.0,
      ),
    );

    // Casa o PADRAO de contador ("1.240 de 3.000"), nao o substring ' de '
    // solto: o rotulo legitimo "Tabelas de referência" contem ' de ' e daria
    // falso negativo independentemente da implementacao.
    expect(find.textContaining(RegExp(r'\d[\d.]* de \d[\d.]*')), findsNothing);
    expect(find.textContaining('/s'), findsNothing);
    expect(find.textContaining('Restam'), findsNothing);
  });

  testWidgets('mostra ritmo e ETA quando disponiveis', (tester) async {
    await montar(
      tester,
      const SyncBaixando(
        etapa: SyncEtapa.animais,
        rotulo: 'Animais',
        progresso: 0.65,
        atual: 1240,
        total: 3000,
        ritmo: 380,
        eta: Duration(seconds: 5),
      ),
    );

    expect(find.textContaining('380/s'), findsOneWidget);
    expect(find.textContaining('Restam ~5s'), findsOneWidget);
  });

  testWidgets('falha no download mostra os dois botoes', (tester) async {
    await montar(
      tester,
      const SyncErro(
        tipo: SyncErroTipo.falhaDownload,
        etapa: SyncEtapa.animais,
        mensagem: 'timeout',
      ),
    );

    expect(find.text('Tentar novamente'), findsOneWidget);
    expect(find.text('Continuar assim mesmo'), findsOneWidget);
  });

  testWidgets('sem conexao mostra so tentar novamente', (tester) async {
    await montar(
      tester,
      const SyncErro(
        tipo: SyncErroTipo.semConexao,
        mensagem: 'Sem conexão com a internet.',
      ),
    );

    expect(find.text('Tentar novamente'), findsOneWidget);
    expect(find.text('Continuar assim mesmo'), findsNothing);
  });

  testWidgets('checklist tem seis linhas', (tester) async {
    expect(linhasVisiveis, hasLength(6));
    expect(linhasVisiveis.contains(SyncEtapa.usuario), false,
        reason: 'usuario e agrupado em referencias');
    expect(linhasVisiveis.contains(SyncEtapa.tecnico), false,
        reason: 'tecnico e agrupado em referencias');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/sincronizacao/sync_progress_view_test.dart`
Expected: FAIL — arquivo inexistente.

- [ ] **Step 3: Write minimal implementation**

Create `lib/features/sincronizacao/presentation/widgets/sync_progress_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/sync/sync_etapa.dart';
import '../../domain/sync_state.dart';

/// Etapas com linha propria na checklist.
///
/// `usuario` e `tecnico` ficam de fora: sao um documento cada e a linha
/// piscaria. As duas sao cobertas pela linha de `referencias`.
const List<SyncEtapa> linhasVisiveis = [
  SyncEtapa.referencias,
  SyncEtapa.produtores,
  SyncEtapa.propriedades,
  SyncEtapa.animais,
  SyncEtapa.acoes,
  SyncEtapa.financeiro,
];

String rotuloLinha(SyncEtapa etapa) => switch (etapa) {
      SyncEtapa.referencias ||
      SyncEtapa.usuario ||
      SyncEtapa.tecnico =>
        'Tabelas de referência',
      SyncEtapa.produtores => 'Produtores',
      SyncEtapa.propriedades => 'Propriedades',
      SyncEtapa.animais => 'Animais',
      SyncEtapa.acoes => 'Ações e tratamentos',
      SyncEtapa.financeiro => 'Financeiro e visitas',
    };

/// Separador de milhar em pt-BR sem depender de `intl`.
String _milhar(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

class SyncProgressView extends StatelessWidget {
  const SyncProgressView({
    super.key,
    required this.estado,
    required this.onTentarNovamente,
    required this.onContinuarAssimMesmo,
  });

  final SyncState estado;
  final VoidCallback onTentarNovamente;
  final VoidCallback onContinuarAssimMesmo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF75E38), Color(0xFFEC3B5B)],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(0.87, -1.0),
          end: AlignmentDirectional(-0.87, 1.0),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: switch (estado) {
              final SyncErro e => _erro(context, e),
              final SyncBaixando e => _baixando(context, e),
              _ => _preparando(context),
            },
          ),
        ),
      ),
    );
  }

  Widget _vaca() => Lottie.asset(
        'assets/jsons/animation_lmv2wwnc.json',
        width: 190.0,
        height: 160.0,
        fit: BoxFit.contain,
        animate: true,
      );

  Widget _preparando(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _vaca(),
          const SizedBox(height: 16),
          const Text(
            'Preparando seus dados',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ],
      );

  Widget _baixando(BuildContext context, SyncBaixando e) {
    final detalhes = <String>[];
    if (e.temContador) {
      detalhes.add('${_milhar(e.atual!)} de ${_milhar(e.total!)}');
      if (e.ritmo != null) detalhes.add('~${e.ritmo!.round()}/s');
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _vaca(),
        const SizedBox(height: 16),
        const Text(
          'Preparando seus dados',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: e.progresso,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${(e.progresso * 100).round()}%',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          e.rotulo,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        if (detalhes.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            detalhes.join(' · '),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
        if (e.eta != null) ...[
          const SizedBox(height: 2),
          Text(
            'Restam ~${e.eta!.inSeconds}s',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
        const SizedBox(height: 24),
        ...linhasVisiveis.map((linha) => _linha(linha, e.etapa)),
      ],
    );
  }

  Widget _linha(SyncEtapa linha, SyncEtapa atual) {
    final indiceLinha = SyncEtapa.values.indexOf(linha);
    final indiceAtual = SyncEtapa.values.indexOf(atual);

    final (icone, cor) = switch (indiceLinha.compareTo(indiceAtual)) {
      < 0 => (Icons.check_circle, Colors.white),
      0 => (Icons.radio_button_checked, Colors.white),
      _ => (Icons.radio_button_unchecked, Colors.white38),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icone, size: 16, color: cor),
          const SizedBox(width: 8),
          Text(
            rotuloLinha(linha),
            style: TextStyle(color: cor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _erro(BuildContext context, SyncErro e) {
    final titulo = e.tipo == SyncErroTipo.semConexao
        ? 'Sem conexão'
        : 'Não foi possível concluir a sincronização';

    final explicacao = e.tipo == SyncErroTipo.semConexao
        ? 'A primeira sincronização precisa de internet. Conecte-se e tente de novo.'
        : e.etapa != null
            ? 'Falhou ao baixar: ${rotuloLinha(e.etapa!)}.'
            : 'Algo deu errado durante a sincronização.';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          e.tipo == SyncErroTipo.semConexao
              ? Icons.cloud_off
              : Icons.error_outline,
          size: 56,
          color: Colors.white,
        ),
        const SizedBox(height: 16),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          explicacao,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            textTheme: Typography.whiteMountainView,
          ),
          child: ExpansionTile(
            iconColor: Colors.white70,
            collapsedIconColor: Colors.white70,
            title: const Text(
              'Detalhes técnicos',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            children: [
              Text(
                e.mensagem,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onTentarNovamente,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFF75E38),
            minimumSize: const Size(double.infinity, 44),
          ),
          child: const Text('Tentar novamente'),
        ),
        if (e.podeContinuarAssimMesmo) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: onContinuarAssimMesmo,
            child: const Text(
              'Continuar assim mesmo',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Você poderá sincronizar depois; nada será perdido.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/sincronizacao/sync_progress_view_test.dart`
Expected: PASS, 6 testes.

Se algum teste falhar porque o asset do Lottie não carrega no ambiente de teste, adicione `errorBuilder: (_, __, ___) => const SizedBox(height: 160)` ao `Lottie.asset`. Não envolva a chamada num `try`/`catch`: a falha acontece durante o build do widget, não na chamada.

- [ ] **Step 5: Commit**

```bash
git add lib/features/sincronizacao/presentation/widgets/sync_progress_view.dart test/features/sincronizacao/sync_progress_view_test.dart
git commit -m "$(cat <<'EOF'
Adiciona a view de progresso da sincronizacao

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
EOF
)"
```

---

### Task 9: `SyncPage`, gateway real e ligação dos fluxos de login

Junta tudo: a página nova, a implementação real do gateway, a rota, a saída do download de dentro do auth manager e o estado de carregando nos botões de login.

**Files:**
- Create: `lib/features/sincronizacao/presentation/pages/sync_page.dart`
- Create: `lib/features/sincronizacao/data/offline_first_sync_gateway.dart`
- Delete: `lib/features/auth/presentation/pages/sync_technician_page.dart`
- Modify: `lib/core/auth/firebase_auth/firebase_auth_manager.dart:315-329`
- Modify: `lib/app/router/nav.dart:494-498`
- Modify: `lib/features/auth/presentation/pages/login_technician_page.dart:391-436, 438-479`
- Modify: `lib/features/produtor/presentation/pages/login_produtor_page.dart:237-320`
- Modify: `lib/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart:1157`
- Modify: `lib/app/app.dart` (override do `syncGatewayProvider`)

**Interfaces:**
- Consumes: tudo das Tasks 6, 7 e 8.
- Produces: `SyncPage` com `routeName = 'sync'`, `routePath = '/sincronizando'`, parâmetro `papel`.

- [ ] **Step 1: Implementar o gateway real**

Create `lib/features/sincronizacao/data/offline_first_sync_gateway.dart`. Este arquivo concentra tudo o que a antiga `SyncTechnicianPage` fazia no `initState` (`sync_technician_page.dart:37-111`):

```dart
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/core/auth/firebase_auth/auth_util.dart';
import '/data/backend.dart';
import '/data/objectbox/index.dart';
import '/features/animais/application/animal_struct_adapter.dart';
import '../domain/sync_gateway.dart';
import '../domain/sync_state.dart';

/// Implementacao real da porta: delega para o `OfflineFirstSyncService` e
/// reproduz a sequencia de pos-login que vivia no `initState` da antiga
/// `SyncTechnicianPage`.
class OfflineFirstSyncGateway implements SyncGateway {
  @override
  bool get temDadosLocais =>
      ObjectBoxService.isInitialized &&
      ObjectBoxService.instance.animalBox.count() > 0;

  @override
  Stream<SyncProgress> get progressStream =>
      OfflineFirstSyncService.instance.progressStream;

  @override
  SyncProgress? get ultimoProgresso =>
      OfflineFirstSyncService.isInitialized
          ? OfflineFirstSyncService.instance.lastProgress
          : null;

  @override
  Future<void> baixarTudo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await ObjectBoxAuthHelper.onUserLogin(user);
  }

  @override
  Future<SyncDestino> concluirLogin(SyncPapel papel) async {
    // Migração legado→ObjectBox: resgata (das prefs) os animais criados
    // offline pelo mecanismo antigo e limpa a chave.
    await migrarAnimaisOfflineLegadoDePrefs();

    final person = await queryPersonRecordOnce(
      queryBuilder: (r) => r.where('uid', isEqualTo: currentUserUid),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    if (person == null) return const DestinoCompletarPerfil();

    if (papel == SyncPapel.produtor) {
      final propriedade = await queryPropriedadesRecordOnce(
        queryBuilder: (r) =>
            r.where('uidPersonProdutor', isEqualTo: person.reference),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      return DestinoInicioPropriedadeProdutor(propriedade);
    }

    final tecnico = await queryTecnicoRecordOnce(
      queryBuilder: (r) => r.where('uidPerson', isEqualTo: person.reference.id),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    if (tecnico == null) return const DestinoCompletarPerfil();

    // Sincronização em tempo real Firestore->ObjectBox: reflete mudanças
    // remotas (ex.: outro dispositivo) automaticamente. Só nativo.
    if (ObjectBoxService.isInitialized) {
      await RemoteSyncListenersService.initialize();
      RemoteSyncListenersService.instance
          .startAllListeners(tecnico.reference.path);
    }

    // Aquecimento de cache do Firestore para as telas seguintes.
    await queryPropriedadesRecordOnce(parent: tecnico.reference);
    await queryAcoesRecordOnce(parent: tecnico.reference);
    await queryResumoDaVisitaRecordOnce(
      queryBuilder: (r) => r.where('uidTecnico', isEqualTo: tecnico.reference),
    );
    await queryTipoAcoesRecordOnce();

    return const DestinoDashboardTecnico();
  }
}
```

- [ ] **Step 2: Registrar o override do provider**

Em `lib/app/app.dart`, localize o `ProviderScope` que envolve o app e adicione o override:

```dart
ProviderScope(
  overrides: [
    syncGatewayProvider.overrideWithValue(OfflineFirstSyncGateway()),
  ],
  child: /* ... o que já estava aqui ... */,
)
```

Com os imports:

```dart
import '/features/sincronizacao/data/offline_first_sync_gateway.dart';
import '/features/sincronizacao/domain/sync_gateway.dart';
```

Se o `ProviderScope` estiver em `lib/main.dart` e não em `app.dart`, faça a mudança lá — rode `grep -rn "ProviderScope" lib/` para localizar.

- [ ] **Step 3: Criar a `SyncPage`**

Create `lib/features/sincronizacao/presentation/pages/sync_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/ui/flutter_flow_util.dart';
import '/data/schema/propriedades_record.dart';
import '/features/dashboard/presentation/pages/dashboard_tecnico_page.dart';
import '/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart';
import '/features/produtor/presentation/pages/inicio_propriedade_produtor_page.dart';
import '../../domain/sync_state.dart';
import '../controllers/sync_page_controller.dart';
import '../widgets/sync_progress_view.dart';

/// Tela de sincronizacao pos-login, para tecnico e produtor.
///
/// Substitui a antiga `SyncTechnicianPage`, que so aparecia DEPOIS que o
/// download completo ja tinha rodado dentro do botao de login.
class SyncPage extends ConsumerStatefulWidget {
  const SyncPage({super.key, required this.papel});

  final SyncPapel papel;

  static String routeName = 'sync';
  static String routePath = '/sincronizando';

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncPageControllerProvider.notifier).iniciar(widget.papel);
    });
  }

  void _navegar(SyncDestino destino) {
    switch (destino) {
      case DestinoDashboardTecnico():
        context.goNamed(DashboardTecnicoPage.routeName);
      case DestinoCompletarPerfil():
        context.goNamed(CompletarPerfilTecnicoPage.routeName);
      case DestinoInicioPropriedadeProdutor(:final propriedade):
        final p = propriedade as PropriedadesRecord?;
        context.goNamed(
          InicioPropriedadeProdutorPage.routeName,
          queryParameters: {
            'nomePropriedade':
                serializeParam(p?.displayName, ParamType.String),
            'uidPropriedade':
                serializeParam(p?.reference, ParamType.DocumentReference),
            'uidTecnico':
                serializeParam(p?.parentReference, ParamType.DocumentReference),
            'emailPropriedade': serializeParam(p?.email, ParamType.String),
            'visitaPresencial': serializeParam(false, ParamType.bool),
            'diasDg': serializeParam(p?.diasParaDg, ParamType.String),
          }.withoutNulls,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(syncPageControllerProvider);

    ref.listen(syncPageControllerProvider, (_, novo) {
      if (novo is SyncConcluido) _navegar(novo.destino);
    });

    // Sair no meio deixaria o usuario autenticado numa tela de login, com o
    // download orfao e o estado pela metade.
    return PopScope(
      canPop: estado is SyncErro,
      child: Scaffold(
        body: SyncProgressView(
          estado: estado,
          onTentarNovamente: () =>
              ref.read(syncPageControllerProvider.notifier).tentarNovamente(),
          onContinuarAssimMesmo: () => ref
              .read(syncPageControllerProvider.notifier)
              .continuarAssimMesmo(),
        ),
      ),
    );
  }
}
```

Confirme o caminho de import de `PropriedadesRecord` e de `InicioPropriedadeProdutorPage` com `grep -rn "class PropriedadesRecord" lib/` e `grep -rn "class InicioPropriedadeProdutorPage" lib/` — ajuste se divergir.

- [ ] **Step 4: Trocar a rota**

Em `lib/app/router/nav.dart`, substitua o `FFRoute` de `SyncTechnicianPage` (`:494-498`) por:

```dart
        FFRoute(
          name: SyncPage.routeName,
          path: SyncPage.routePath,
          builder: (context, params) => SyncPage(
            papel: params.getParam('papel', ParamType.String) == 'produtor'
                ? SyncPapel.produtor
                : SyncPapel.tecnico,
          ),
        ),
```

Troque o import de `sync_technician_page.dart` por:

```dart
import '/features/sincronizacao/presentation/pages/sync_page.dart';
import '/features/sincronizacao/domain/sync_state.dart';
```

- [ ] **Step 5: Tirar o download do auth manager**

Em `lib/core/auth/firebase_auth/firebase_auth_manager.dart`, remova o bloco de sincronização de `_signInOrCreateAccount` (`:324-327`), deixando:

```dart
    try {
      final userCredential = await signInFunc();
      if (userCredential == null) return null;

      // A sincronizacao roda na tela de sincronizacao, nao aqui: dentro deste
      // await, o download completo de um tecnico com milhares de animais
      // travava o botao de login por dezenas de segundos sem nenhum aviso.
      return TecmuuFirebaseUser.fromUserCredential(userCredential);
```

Remova o import de `objectbox_auth_helper.dart` se ele ficar sem uso (o `flutter analyze` acusa).

- [ ] **Step 6: Ligar o login do técnico**

Em `lib/features/auth/presentation/pages/login_technician_page.dart`:

Troque o import `'/features/auth/presentation/pages/sync_technician_page.dart'` (linha 15) por:

```dart
import '/features/sincronizacao/presentation/pages/sync_page.dart';
import '/features/sincronizacao/domain/sync_state.dart';
```

Adicione um campo de estado logo abaixo de `final scaffoldKey` (linha 39):

```dart
  bool _entrando = false;
```

Substitua o `onPressed` e o `text` do `_botaoEntrar` (`:395-409`) por:

```dart
        onPressed: _entrando
            ? null
            : () async {
                setState(() => _entrando = true);
                try {
                  GoRouter.of(context).prepareAuthEvent();

                  final user = await authManager.signInWithEmail(
                    context,
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (user == null) return;
                  if (!context.mounted) return;

                  context.pushNamedAuth(
                    SyncPage.routeName,
                    context.mounted,
                    queryParameters: {'papel': 'tecnico'},
                  );
                } finally {
                  if (mounted) setState(() => _entrando = false);
                }
              },
        text: _entrando ? 'Entrando...' : 'Entrar',
```

E no `_botaoBiometria` (`:453-456`):

```dart
              if (session != null && context.mounted) {
                context.pushNamedAuth(
                  SyncPage.routeName,
                  context.mounted,
                  queryParameters: {'papel': 'tecnico'},
                );
              }
```

- [ ] **Step 7: Ligar o login do produtor**

Em `lib/features/produtor/presentation/pages/login_produtor_page.dart`, substitua `_handleLogin`, `_handleLoginBiometria`, `_afterLogin` e `_navigateToHome` (`:237-320`) por:

```dart
  /// Processa o login do usuário.
  Future<void> _handleLogin() async {
    setState(() => _entrando = true);
    try {
      GoRouter.of(context).prepareAuthEvent();

      final user = await authManager.signInWithEmail(
        context,
        _emailController.text,
        _passwordController.text,
      );

      if (user == null) return;
      if (!mounted) return;

      _irParaSincronizacao();
    } finally {
      if (mounted) setState(() => _entrando = false);
    }
  }

  /// Login offline por biometria/PIN: reabre a sessão sem digitar a senha.
  Future<void> _handleLoginBiometria() async {
    final service = await OfflineAuthService.instance;
    final session = await service.loginOfflineComBiometria();
    if (session == null || !mounted) return;
    _irParaSincronizacao();
  }

  /// A busca de person/propriedade e a navegacao final vivem agora no
  /// `OfflineFirstSyncGateway`, atras da tela de sincronizacao.
  void _irParaSincronizacao() {
    context.pushNamedAuth(
      SyncPage.routeName,
      context.mounted,
      queryParameters: {'papel': 'produtor'},
    );
  }
```

Adicione o campo `bool _entrando = false;` junto aos outros campos do `State`, e aplique o mesmo tratamento de `onPressed: _entrando ? null : _handleLogin` e rótulo `_entrando ? 'Entrando...' : 'Entrar'` no botão de entrar dessa tela.

Remova os imports que ficarem sem uso (`InicioPropriedadeProdutorPage`, `PropriedadesRecord`) — `flutter analyze` aponta.

- [ ] **Step 8: Ligar a criação de conta**

Em `lib/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart:1157`, troque:

```dart
                context.pushNamed(
                  SyncPage.routeName,
                  queryParameters: {'papel': 'tecnico'},
                );
```

Ajuste o import de `sync_technician_page.dart` para `sync_page.dart`.

- [ ] **Step 9: Apagar a página antiga**

```bash
git rm lib/features/auth/presentation/pages/sync_technician_page.dart
```

- [ ] **Step 10: Verify**

Run: `grep -rn "SyncTechnicianPage" lib/ test/`
Expected: nenhuma ocorrência.

Run: `flutter analyze`
Expected: sem erros.

Run: `flutter test`
Expected: PASS na suíte inteira.

- [ ] **Step 11: Commit**

Adicione apenas os arquivos desta tarefa. **Nunca use `git add -A`** aqui: o working
tree tem mudanças não relacionadas do usuário (`pubspec.yaml`, `pubspec.lock`,
`.flutter-plugins-dependencies`, `layout_inspirations/`) que não podem entrar neste
commit.

```bash
git add lib/features/sincronizacao/ \
        lib/core/auth/firebase_auth/firebase_auth_manager.dart \
        lib/app/router/nav.dart \
        lib/app/app.dart \
        lib/features/auth/presentation/pages/login_technician_page.dart \
        lib/features/produtor/presentation/pages/login_produtor_page.dart \
        lib/features/perfil/presentation/pages/completar_perfil_tecnico_page.dart
git add -u lib/features/auth/presentation/pages/sync_technician_page.dart
git commit -m "$(cat <<'EOF'
Tira o download completo de dentro do botao de login

O download rodava dentro do onPressed do botao Entrar, entao no primeiro
login de um tecnico com ~3000 animais o botao travava sem aviso e a tela
de sincronizacao so aparecia depois que tudo ja tinha baixado. Agora o
login navega direto para a tela, que baixa mostrando etapa, porcentagem,
contador, ritmo e ETA. Produtor passa a usar a mesma tela.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
EOF
)"
```

---

### Task 10: Validação no dispositivo

Não é código; é o gate final. **Depende do usuário**, que se ofereceu para fazer o login de um técnico com muitos dados.

- [ ] **Step 1: Preparar o build**

Run: `flutter run --release` com o aparelho conectado. Release e não debug: em debug, o ObjectBox e o Flutter rodam com asserts e a percepção de velocidade não representa o que o técnico vê.

- [ ] **Step 2: Primeiro login (instalação limpa)**

Peça ao usuário para desinstalar o app antes. Sem isso, `needsInitialSync()` retorna falso, o download completo não roda e o cenário do bug não se reproduz.

Verificar:
- O botão "Entrar" mostra "Entrando..." e volta ao normal em poucos segundos.
- A tela de sincronização aparece **antes** do download, não depois.
- A barra anima durante a etapa de animais (o teste real do batch da Task 3).
- O contador sobe de 250 em 250 até o total do técnico.
- Ritmo e ETA aparecem depois de ~2s e não pulam de forma absurda.
- A checklist marca as seis linhas na ordem.
- Ao final, vai para o dashboard do técnico e o botão físico de voltar **não** retorna à tela de sincronização.

- [ ] **Step 3: Segundo login**

Sair e entrar de novo com o mesmo técnico. Verificar:
- A tela passa rápido (só sincroniza pendências).
- O número de animais no app **não dobrou** — é a regressão de índice único que a Task 3 protege.

- [ ] **Step 4: Modo avião**

Com dados já baixados, ativar modo avião e entrar por biometria. Verificar que atravessa a tela direto, sem erro.

Depois, desinstalar, ativar modo avião e tentar entrar: deve aparecer a tela "Sem conexão" com apenas "Tentar novamente".

- [ ] **Step 5: Login do produtor**

Repetir os passos 2 e 3 com um produtor, confirmando que ele agora passa pela tela e chega em `InicioPropriedadeProdutorPage` com a propriedade certa (nome no topo, dados carregados).

---

## Notas de execução

**Ordem de dependência:** 1 e 2 são independentes e podem ir em qualquer ordem. 3 depende de nada além do código existente. 4 depende de 2. 5 depende de 2. 6 depende de 2. 7 depende de 1, 2, 4, 5 e 6. 8 depende de 2 e 6. 9 depende de 7 e 8. 10 depende de 9.

**Fora de escopo** (confirmado com o usuário): `_downloadFinanceiroEVisitas` mantém o padrão atual de gravação; `RemoteSyncListenersService` fica inalterado; abrir o app com sessão já salva continua sem passar por tela de sincronização.
