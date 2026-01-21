# Guia de Implementação - Correções de Performance

## 1. IMPLEMENTAÇÃO RÁPIDA - InstantTimer

### Problema Atual
```dart
// ❌ ERRADO - em inicio_propriedade_widget.dart, listacompleta_widget.dart, resumo_rebanho_widget.dart
_model.instantTimer = InstantTimer.periodic(
  duration: Duration(milliseconds: 300),
  callback: (timer) async {
    _model.respostaNet = await actions.checkInternetConnection();
    safeSetState(() {});
  },
  startImmediately: true,
);
```

### Solução
```dart
// ✅ CORRETO
_model.instantTimer = InstantTimer.periodic(
  duration: Duration(seconds: 10),  // Aumentar para 10 segundos
  callback: (timer) async {
    if (!mounted) {  // Verificar se widget ainda está vivo
      timer.cancel();
      return;
    }
    _model.respostaNet = await actions.checkInternetConnection();
    safeSetState(() {});
  },
  startImmediately: true,
);

@override
void dispose() {
  _model.instantTimer?.cancel();  // ✅ Garantir cancelamento
  _model.dispose();
  super.dispose();
}
```

---

## 2. IMPLEMENTAÇÃO RÁPIDA - context.watch()

### Problema Atual
```dart
// ❌ ERRADO - em listacompleta_widget.dart, resumo_rebanho_widget.dart
@override
Widget build(BuildContext context) {
  context.watch<FFAppState>();  // Rebuild de TUDO quando FFAppState muda
  
  return Scaffold(
    // ... 22.000+ linhas
  );
}
```

### Solução - Opção 1 (Simples)
```dart
// ✅ CORRETO - Usar context.select ao invés de context.watch
@override
Widget build(BuildContext context) {
  // Só rebuild se verificaInternet mudar
  final verificaInternet = context.select<FFAppState, int>(
    (state) => state.verificaInternet,
  );
  
  return Scaffold(
    appBar: AppBar(
      backgroundColor: verificaInternet == -1 ? Color(0xFFF75E38) : Color(0xFFF2886E),
      // ... resto
    ),
    // ... resto da UI
  );
}
```

### Solução - Opção 2 (Melhor - Extração)
```dart
// ✅ CORRETO - Extrair em sub-widget que observa só o que precisa
class _AppBarWithNetworkStatus extends StatelessWidget {
  const _AppBarWithNetworkStatus({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final verificaInternet = context.select<FFAppState, int>(
      (state) => state.verificaInternet,
    );

    return AppBar(
      backgroundColor: verificaInternet == -1 ? Color(0xFFF75E38) : Color(0xFFF2886E),
      title: Text(title),
    );
  }
}

// Usar assim:
@override
Widget build(BuildContext context) {
  // ✅ Resto da página NÃO rebuild
  return Scaffold(
    appBar: _AppBarWithNetworkStatus(title: 'Lista Completa'),
    body: Center(child: CircularProgressIndicator()),
  );
}
```

---

## 3. IMPLEMENTAÇÃO RÁPIDA - Descartar Listeners em main.dart

### Problema Atual
```dart
// ❌ ERRADO - em main.dart
class _MyAppState extends State<MyApp> {
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    
    userStream = tecmuuFirebaseUserStream()
      ..listen((user) {  // ❌ Listener nunca descartado
        _appStateNotifier.update(user);
      });
    
    jwtTokenStream.listen((_) {});  // ❌ Listener nunca descartado
  }
  
  // ❌ Sem dispose()
}
```

### Solução
```dart
// ✅ CORRETO
class _MyAppState extends State<MyApp> {
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late StreamSubscription<BaseAuthUser> _userSubscription;  // ✅ Armazenar
  late StreamSubscription _jwtSubscription;  // ✅ Armazenar

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    
    // ✅ Armazenar as subscriptions
    _userSubscription = tecmuuFirebaseUserStream()
      .listen((user) {
        _appStateNotifier.update(user);
      });
    
    _jwtSubscription = jwtTokenStream.listen((_) {});
    
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    // ✅ Descartar subscriptions
    _userSubscription.cancel();
    _jwtSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... resto igual
  }
}
```

---

## 4. IMPLEMENTAÇÃO RÁPIDA - Adicionar Limit nas Queries

### Problema Atual
```dart
// ❌ ERRADO - em backend.dart (linhas 73, 83, 96, etc)
Stream<List<CidadesRecord>> queryCidadesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,  // ❌ -1 = sem limite
  bool singleRecord = false,
}) =>
    queryCollection(
      CidadesRecord.collection,
      CidadesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );
```

### Solução
```dart
// ✅ CORRETO - Adicionar limite padrão seguro
Stream<List<CidadesRecord>> queryCidadesRecord({
  Query Function(Query)? queryBuilder,
  int limit = 50,  // ✅ Limite padrão seguro
  bool singleRecord = false,
}) =>
    queryCollection(
      CidadesRecord.collection,
      CidadesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

// ✅ Aplicar para TODAS as funções query* em backend.dart:
// queryGrupoRecord, queryStatusAnimaisRecord, queryPlanosProdutorRecord, etc
```

---

## 5. IMPLEMENTAÇÃO - Substituir context.watch em listacompleta_widget.dart

### Problema
```dart
// ❌ ERRADO - linhas ~150 em listacompleta_widget.dart
@override
Widget build(BuildContext context) {
  context.watch<FFAppState>();

  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: Scaffold(
      // ... 22.000+ linhas que fazem rebuild sempre
    ),
  );
}
```

### Solução
```dart
// ✅ CORRETO - Extrair AppBar em sub-widget
class _ListacompletaAppBar extends StatelessWidget {
  final String nomePropriedade;
  final DocumentReference uidPropriedade;
  // ... outros params

  const _ListacompletaAppBar({
    required this.nomePropriedade,
    required this.uidPropriedade,
    // ...
  });

  @override
  Widget build(BuildContext context) {
    // ✅ SÓ este widget observa FFAppState
    final respostaNet = context.select<FFAppState, bool>(
      (state) => state.verificaInternet == -1,
    );

    return AppBar(
      backgroundColor: respostaNet ? Color(0xFFF75E38) : Color(0xFFF2886E),
      automaticallyImplyLeading: false,
      // ... resto do AppBar
    );
  }
}

// ✅ USAR NA PÁGINA PRINCIPAL
@override
Widget build(BuildContext context) {
  // ✅ SEM context.watch() aqui
  
  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: Scaffold(
      appBar: _ListacompletaAppBar(
        nomePropriedade: widget.nomePropriedade!,
        uidPropriedade: widget.uidPropriedade!,
        // ...
      ),
      body: Container(
        // ... resto da UI, SEM rebuild quando verificaInternet muda
      ),
    ),
  );
}
```

---

## 6. IMPLEMENTAÇÃO - FFAppState com Hive (Melhor Cache)

### Problema Atual
```dart
// ❌ LENTO - em app_state.dart
Future initializePersistedState() async {
  prefs = await SharedPreferences.getInstance();
  _safeInit(() {
    _grupo = prefs
        .getStringList('ff_grupo')
        ?.map((x) {
          try {
            return GrupoStruct.fromSerializableMap(jsonDecode(x));  // ❌ JSON decode
          } catch (e) {
            print("Can't decode persisted data type. Error: $e.");
            return null;
          }
        })
        .withoutNulls
        .toList() ?? _grupo;
  });
  // ... repetir 50+ vezes para cada lista
}
```

### Solução com Hive
```dart
// ✅ RÁPIDO - usar Hive ao invés de SharedPreferences
import 'package:hive/hive.dart';

class FFAppState extends ChangeNotifier {
  late Box<List<GrupoStruct>> grupoBox;
  late Box<List<RacasStruct>> racasBox;
  late Box<List<AnimaisProdutoresStruct>> animaisBox;
  // ... etc

  Future initializePersistedState() async {
    // ✅ Hive é muito mais rápido que jsonDecode
    grupoBox = await Hive.openBox<List<GrupoStruct>>('ff_grupo');
    racasBox = await Hive.openBox<List<RacasStruct>>('ff_racas');
    animaisBox = await Hive.openBox<List<AnimaisProdutoresStruct>>('ff_animais');
    
    _grupo = grupoBox.get('data') ?? _grupo;
    _racas = racasBox.get('data') ?? _racas;
    // ... etc
  }

  List<GrupoStruct> _grupo = [];
  List<GrupoStruct> get grupo => _grupo;
  set grupo(List<GrupoStruct> value) {
    _grupo = value;
    grupoBox.put('data', value);  // ✅ Salvar async
  }

  // ✅ LAZY LOAD - carregar apenas quando necessário
  Future<List<AnimaisProdutoresStruct>> loadAnimaisProdutor(String uid) async {
    if (!animaisBox.containsKey(uid)) {
      // Carregar do Firestore
      final data = await queryAnimaisProdutoresRecordOnce(parent: uid);
      animaisBox.put(uid, data);
    }
    return animaisBox.get(uid) ?? [];
  }
}

// pubspec.yaml - Adicionar:
// hive: ^2.2.3
// hive_flutter: ^1.1.0
```

---

## 7. IMPLEMENTAÇÃO - Paginação em listacompleta_widget.dart

### Problema Atual
```dart
// ❌ Carrega TODOS os animais
ListView.builder(
  itemCount: listViewAnimaisProdutoresRecordList.length,  // 5000+?
  itemBuilder: (context, index) {
    final animal = listViewAnimaisProdutoresRecordList[index];
    return Card(...);  // Render cada um
  },
)
```

### Solução com Paginação
```dart
// ✅ CORRETO - usar PagedListView
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class _ListacompletaWidgetState extends State<ListacompletaWidget> {
  static const _pageSize = 50;  // ✅ Paginar 50 por vez
  
  late PagingController<int, AnimaisProdutoresRecord> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // ✅ Fetch com limit e offset
      final newItems = await queryAnimaisProdutoresRecordOnce(
        parent: widget.uidTecnico,
        queryBuilder: (q) => q
            .where('uidTecnicoPropriedade', isEqualTo: widget.uidPropriedade)
            .orderBy('nomeAnimal')
            .limit(_pageSize)
            .offset(pageKey * _pageSize),  // ✅ Pagination
      );

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, AnimaisProdutoresRecord>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<AnimaisProdutoresRecord>(
        itemBuilder: (context, item, index) => Card(
          // ✅ Renderizar item
          child: ListTile(title: Text(item.nomeAnimal)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

// pubspec.yaml - Adicionar:
// infinite_scroll_pagination: ^3.2.0
```

---

## 8. IMPLEMENTAÇÃO - CachedNetworkImage

### Problema Atual
```dart
// ❌ Baixa cada vez que rebuild
Image.network(
  imageUrl,
  fit: BoxFit.cover,
)
```

### Solução
```dart
// ✅ CORRETO - Cache automático
import 'package:cached_network_image/cached_network_image.dart';

CachedNetworkImage(
  imageUrl: imageUrl,
  fit: BoxFit.cover,
  placeholder: (context, url) => Container(
    color: Colors.grey[300],
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
  fadeInDuration: Duration(milliseconds: 300),
  cacheManager: CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  ),
)

// pubspec.yaml - Adicionar:
// cached_network_image: ^3.2.3
```

---

## 9. Checklist de Implementação

### Semana 1 - CRÍTICO
- [ ] Aumentar InstantTimer (300ms → 10s) em 3 widgets
- [ ] Adicionar `if (!mounted)` checks
- [ ] Garantir `timer.cancel()` em dispose
- [ ] Aplicar context.select() em AppBar/header
- [ ] Descartar listeners em main.dart
- [ ] Adicionar limit=50 em backend.dart

**Resultado esperado:** -40% CPU, -30% memória

### Semana 2-3 - IMPORTANTE
- [ ] Implementar Hive em app_state.dart
- [ ] Adicionar lazy loading para dados grandes
- [ ] Implementar paginação em listacompleta
- [ ] Implementar CachedNetworkImage

**Resultado esperado:** -50% startup time, -70% memória

### Semana 4+ - OTIMIZAÇÕES
- [ ] Extrair sub-widgets (dividir listacompleta)
- [ ] Adicionar índices Firestore
- [ ] Otimizar animações

---

## 10. Profiling - Como Validar Melhorias

### Using Flutter DevTools
```bash
# Terminal
flutter pub global activate devtools
flutter pub global run devtools

# Depois abra seu app em debug
# Acesse http://localhost:9100
```

### Verificar Antes e Depois

1. **Memory Tab**
   - Antes: 150-200MB em repouso
   - Depois (alvo): 50-80MB em repouso

2. **Performance Tab**
   - Antes: Jank/frame drops ao navegar
   - Depois: 60 FPS stabil

3. **CPU Profiler**
   - Antes: Picos de 80%+ durante timer
   - Depois: <20% baseline

4. **Timeline**
   - Antes: Build time 2-3s por rebuild
   - Depois: Build time <500ms

---

## Próximas Etapas

1. ✅ Copiar este arquivo para o projeto
2. ✅ Implementar Semana 1 - CRÍTICO
3. ✅ Validar com DevTools
4. ✅ Abrir PR para revisão
5. ✅ Medir melhoria antes/depois
6. ✅ Documentar resultados

**Tempo estimado para Fase 1:** 4-6 horas de trabalho

