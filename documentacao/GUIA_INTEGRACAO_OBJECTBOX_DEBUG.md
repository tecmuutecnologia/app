# 🔧 Como Integrar ObjectBox Debug Menu ao App

## Opção 1: Adicionar Rota Debug (Recomendado)

Se você usa `GoRouter` para navegação:

### Passo 1: Adicionar Rota

```dart
// lib/flutter_flow/flutter_flow_theme.dart 
// ou seu arquivo de rotas (createRouter)

import 'package:tecmuu/backend/objectbox/widgets/objectbox_debug_menu.dart';

// Em suas rotas GoRouter:
GoRoute(
  path: '/debug/objectbox',
  builder: (context, state) => const ObjectBoxDebugMenu(),
),
```

### Passo 2: Acessar

Navegue para `http://localhost/debug/objectbox` (se web) ou:

```dart
// Em qualquer página
context.go('/debug/objectbox');
```

---

## Opção 2: Adicionar Botão Secreto

### Passo 1: Criar Botão Long Press

```dart
// Em lib/main.dart ou AppBar

import 'package:tecmuu/backend/objectbox/widgets/objectbox_debug_menu.dart';

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onLongPress: () {
          // Long press em qualquer lugar abre debug menu
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ObjectBoxDebugMenu(),
            ),
          );
        },
        child: MyHomePage(),
      ),
    );
  }
}
```

---

## Opção 3: Adicionar Tab Debug

Se tem TabBar, adicione aba extra em debug:

```dart
@override
Widget build(BuildContext context) {
  final tabs = [
    Tab(text: 'Home'),
    Tab(text: 'Dados'),
    // ... outras abas
  ];

  // Em debug, add tab de debug
  if (kDebugMode) {
    tabs.add(Tab(text: '🔧 Debug'));
  }

  return DefaultTabController(
    length: tabs.length,
    child: Scaffold(
      appBar: AppBar(
        bottom: TabBar(tabs: tabs),
      ),
      body: TabBarView(
        children: [
          HomePage(),
          DataPage(),
          // ... outras páginas
          if (kDebugMode) const ObjectBoxDebugMenu(),
        ],
      ),
    ),
  );
}
```

---

## Opção 4: Menu Flutuante

Adicione um botão flutuante que abre debug:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: kDebugMode
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ObjectBoxDebugMenu(),
                    ),
                  );
                },
                tooltip: 'Debug ObjectBox',
                child: Icon(Icons.bug_report),
              )
            : null,
        body: MyHomePage(),
      ),
    );
  }
}
```

---

## Opção 5: Debug Drawer

Adicione menu no drawer:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    drawer: Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Menu')),
          ListTile(
            title: Text('Home'),
            onTap: () { /* ... */ },
          ),
          // ... outros itens
          if (kDebugMode) ...[
            Divider(),
            ListTile(
              title: Text('🔧 Debug ObjectBox'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ObjectBoxDebugMenu(),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    ),
    // ... resto do scaffold
  );
}
```

---

## Configuração Recomendada

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # ObjectBox
  objectbox: ^2.0.0
  objectbox_flutter_admin: ^0.3.0  # ← Adicione isto
  
  # ... outras dependências

dev_dependencies:
  flutter_test:
    sdk: flutter
  objectbox_generator: ^2.0.0
  build_runner: ^2.0.0
```

### main.dart (Exemplo Completo)

```dart
import 'package:flutter/foundation.dart';
import 'package:tecmuu/backend/objectbox/widgets/objectbox_debug_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ... inicializações
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tecmuu'),
          actions: [
            // Botão debug na AppBar em kDebugMode
            if (kDebugMode)
              IconButton(
                icon: Icon(Icons.bug_report),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ObjectBoxDebugMenu(),
                    ),
                  );
                },
              ),
          ],
        ),
        body: HomePage(),
      ),
    );
  }
}
```

---

## 🚀 Uso Rápido

### 1. Adicione Dependência

```bash
flutter pub add objectbox_flutter_admin
```

### 2. Escolha Integração (Recomendo: Rota + Tab)

### 3. Execute

```bash
flutter run
```

### 4. Acesse Debug Menu

- Clique no ícone 🔧
- Ou navegue para rota debug
- Ou long press no app

### 5. Clique "Iniciar Admin"

```
localhost:8090 abre no navegador
```

---

## 🔍 Verificando se Funcionou

### No Console

```
✅ ObjectBox Admin iniciado!
🌐 Acesse: http://localhost:8090
```

### No Navegador (PC/Mac)

```
http://localhost:8090
↓
Vê suas collections: Person, Animal, Propriedade, etc
↓
Pode editar dados em tempo real
```

---

## ⚙️ Configuração Avançada

### Porta Customizada

```dart
// Se porta 8090 já está em uso
ObjectBoxDebugService.startAdmin(port: 9090);
```

### Apenas em Debug

```dart
// Garantir que não aparece em release
if (kDebugMode) {
  // Adicionar widget debug aqui
}
```

### Log Automático ao Iniciar

```dart
// No main.dart após inicializar ObjectBox
if (kDebugMode) {
  ObjectBoxDebugService.printDatabaseStats();
}
```

---

## 🎯 Checklist

- [ ] Adicionar `objectbox_flutter_admin` ao pubspec.yaml
- [ ] Importar `ObjectBoxDebugMenu` onde usar
- [ ] Wrappear com `if (kDebugMode)` para segurança
- [ ] Testar: `flutter run` e acessar
- [ ] Verificar console: "✅ ObjectBox Admin iniciado!"
- [ ] Abrir localhost:8090 no navegador
- [ ] Ver suas collections aparecerem

---

**Status:** ✅ PRONTO PARA INTEGRAÇÃO  
**Data:** 1 de junho de 2026
