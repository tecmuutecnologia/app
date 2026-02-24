# 📚 Documentação Técnica - Ações Favoritas

## 📖 Sumário

1. [Arquitetura](#arquitetura)
2. [Fluxo de Dados](#fluxo-de-dados)
3. [Componentes](#componentes)
4. [Integração](#integração)
5. [Persistência](#persistência)
6. [Exemplos de Código](#exemplos-de-código)

---

## Arquitetura

### Componentes Principais

```
┌─────────────────────────────────────────────┐
│           FFAppState (app_state.dart)       │
│  - _acoesPreferidas: List<String>           │
│  - addToAcoesPreferidas()                   │
│  - removeFromAcoesPreferidas()              │
│  - isAcaoPreferida()                        │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│      AcoesDropdownCustom Widget             │
│  - Exibe lista de ações                     │
│  - Mostra estrelas (favoritas/não)          │
│  - Permite clicar para favoritar            │
│  - Ordena favoritas primeiro                │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│   3 Widgets Nova Ação Exame Ginecológico   │
│  - nova_acao_exame_ginecologico_widget      │
│  - nova_acao_..._existente_offline_widget   │
│  - nova_acao_..._offline_widget             │
└─────────────────────────────────────────────┘
```

---

## Fluxo de Dados

### 1. Inicialização

```dart
// No main.dart / app_state.dart
FFAppState().initializePersistedState()
  └─> Carrega _acoesPreferidas do SharedPreferences
      └─> Se não existir, inicia lista vazia []
```

### 2. Renderização do Dropdown

```dart
AcoesDropdownCustom(
  opcoes: ['Aborto', 'Anestro', 'Cio', ...],
  isFavorite: (acao) => FFAppState().isAcaoPreferida(acao)
)
  └─> initState()
      └─> _sortOpcoes()
          └─> Ordena: favoritas primeiro, depois alfabética
```

### 3. Marcar como Favorita

```dart
user clicks star for 'Anestro'
  └─> onToggleFavorite('Anestro')
      └─> if (isAcaoPreferida('Anestro'))
            ├─> removeFromAcoesPreferidas('Anestro')
            └─> prefs.setStringList('ff_acoesPreferidas', updatedList)
          else
            ├─> addToAcoesPreferidas('Anestro')
            └─> prefs.setStringList('ff_acoesPreferidas', updatedList)
      └─> setState() → lista re-renderiza
```

---

## Componentes

### 1. FFAppState (app_state.dart)

```dart
// Declaração da variável
List<String> _acoesPreferidas = [];
List<String> get acoesPreferidas => _acoesPreferidas;
set acoesPreferidas(List<String> value) {
  _acoesPreferidas = value;
  prefs.setStringList('ff_acoesPreferidas', value);
}

// Métodos de manipulação
void addToAcoesPreferidas(String value) {
  acoesPreferidas.add(value);
  prefs.setStringList('ff_acoesPreferidas', _acoesPreferidas);
}

void removeFromAcoesPreferidas(String value) {
  acoesPreferidas.remove(value);
  prefs.setStringList('ff_acoesPreferidas', _acoesPreferidas);
}

bool isAcaoPreferida(String acao) {
  return _acoesPreferidas.contains(acao);
}

// Inicialização
void initializePersistedState() {
  _safeInit(() {
    _acoesPreferidas = prefs.getStringList('ff_acoesPreferidas') 
      ?? _acoesPreferidas;
  });
}
```

### 2. AcoesDropdownCustom (acoes_dropdown_custom.dart)

#### Props

```dart
final List<String> opcoes;           // Lista de ações disponíveis
final String? valueSelected;         // Ação selecionada
final Function(String?) onChanged;   // Callback seleção
final Function(String)? onToggleFavorite; // Callback favorito
final Function(String) isFavorite;   // Check se é favorita
```

#### Método Principais

```dart
void _sortOpcoes() {
  _sortedOpcoes = List<String>.from(widget.opcoes);
  _sortedOpcoes.sort((a, b) {
    bool aIsFav = widget.isFavorite(a);
    bool bIsFav = widget.isFavorite(b);
    if (aIsFav && !bIsFav) return -1;      // a vem primeiro
    if (!aIsFav && bIsFav) return 1;       // b vem primeiro
    return a.compareTo(b);                 // ordem alfabética
  });
}
```

#### Build

```dart
DropdownButton<String>(
  items: _sortedOpcoes.map((value) {
    bool isFav = widget.isFavorite(value);
    return DropdownMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Expanded(child: Text(value)),
          GestureDetector(
            onTap: () {
              widget.onToggleFavorite?.call(value);
              setState(() => _sortOpcoes());
            },
            child: Icon(
              isFav ? Icons.star : Icons.star_outline,
              color: isFav ? Colors.amber : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }).toList(),
)
```

### 3. Widgets de Ações (3 versões)

#### Integração no Build

```dart
AcoesDropdownCustom(
  opcoes: FFAppState()
    .tipoAcoes
    .map((e) => e.descricao)
    .toList(),
  valueSelected: _model.acoesDispoValue,
  onChanged: (val) =>
    safeSetState(() => _model.acoesDispoValue = val),
  onToggleFavorite: (acao) {
    if (FFAppState().isAcaoPreferida(acao)) {
      FFAppState().removeFromAcoesPreferidas(acao);
    } else {
      FFAppState().addToAcoesPreferidas(acao);
    }
    safeSetState(() {});
  },
  isFavorite: (acao) => FFAppState().isAcaoPreferida(acao),
),
```

---

## Integração

### Widgets que usam a funcionalidade

1. **nova_acao_exame_ginecologico_widget.dart**
   - Caminho: `/lib/pages/tecnico/propriedade/exame_ginecologico/nova_acao_exame_ginecologico/`
   - Tipo: Online (Firebase)
   - Status: ✅ Integrado

2. **nova_acao_exame_ginecologico_existente_offline_widget.dart**
   - Caminho: `/lib/pages/tecnico/propriedade/exame_ginecologico/nova_acao_exame_ginecologico_existente_offline/`
   - Tipo: Offline (dados existentes)
   - Status: ✅ Integrado

3. **nova_acao_exame_ginecologico_offline_widget.dart**
   - Caminho: `/lib/pages/tecnico/propriedade/exame_ginecologico/nova_acao_exame_ginecologico_offline/`
   - Tipo: Offline (novo registro)
   - Status: ✅ Integrado

### Imports Necessários

Em cada widget, adicionar:
```dart
import '/pages/tecnico/propriedade/exame_ginecologico/nova_acao_exame_ginecologico/acoes_dropdown_custom.dart';
```

---

## Persistência

### SharedPreferences

**Chave**: `ff_acoesPreferidas`
**Tipo**: `List<String>`
**Formato**: 
```json
["Aborto", "Cio", "Inseminação"]
```

### Ciclo de Vida

```
App Iniciado
  ↓
initializePersistedState()
  ↓
Carrega 'ff_acoesPreferidas' do SharedPreferences
  ↓
_acoesPreferidas = ["Aborto", "Cio", ...]
  ↓
User marca nova favorita
  ↓
addToAcoesPreferidas(newValue)
  ↓
prefs.setStringList('ff_acoesPreferidas', updatedList)
  ↓
Salvo persistentemente no dispositivo
```

### Recuperação

```dart
// Na próxima execução do app
FFAppState state = FFAppState();
await state.initializePersistedState();
// _acoesPreferidas é restaurada automaticamente
```

---

## Exemplos de Código

### Exemplo 1: Adicionar Favorita

```dart
// Usuário clica na estrela de 'Cio'
void _onStarTapped(String acao) {
  if (!FFAppState().isAcaoPreferida(acao)) {
    FFAppState().addToAcoesPreferidas(acao);
    // Automaticamente salvo em SharedPreferences
    
    // Atualiza UI
    setState(() {});
  }
}
```

### Exemplo 2: Remover Favorita

```dart
// Usuário clica novamente na estrela
void _onStarTapped(String acao) {
  if (FFAppState().isAcaoPreferida(acao)) {
    FFAppState().removeFromAcoesPreferidas(acao);
    // Automaticamente salvo em SharedPreferences
    
    // Atualiza UI
    setState(() {});
  }
}
```

### Exemplo 3: Verificar Favoritas

```dart
// Em qualquer lugar do app
List<String> favoritas = FFAppState().acoesPreferidas;
// favoritas = ["Aborto", "Cio", "Inseminação"]

bool isAborteFavorita = FFAppState().isAcaoPreferida("Aborto");
// isAborteFavorita = true
```

### Exemplo 4: Ordenação

```dart
void _sortOpcoes() {
  List<String> opcoes = ['Aborto', 'Cio', 'Anestro', 'Inseminação'];
  
  opcoes.sort((a, b) {
    bool aIsFav = FFAppState().isAcaoPreferida(a);
    bool bIsFav = FFAppState().isAcaoPreferida(b);
    
    // Favoritas primeiro
    if (aIsFav && !bIsFav) return -1;      // a vem antes
    if (!aIsFav && bIsFav) return 1;       // b vem antes
    
    // Se ambas são favoritas ou ambas não, orden alfabética
    return a.compareTo(b);
  });
  
  // Resultado: ['Cio', 'Inseminação', 'Aborto', 'Anestro']
  //             (favoritas primeiro, depois alfabética)
}
```

---

## Melhorias Futuras

### 1. Limite de Favoritas
```dart
static const int MAX_FAVORITAS = 5;

bool canAddFavorite(String acao) {
  return _acoesPreferidas.length < MAX_FAVORITAS 
    || _acoesPreferidas.contains(acao);
}
```

### 2. Ordenação por Frequência
```dart
Map<String, int> _frecuenciaAcoes = {};

void recordarUsoDaAcao(String acao) {
  _frecuenciaAcoes[acao] = (_frecuenciaAcoes[acao] ?? 0) + 1;
}
```

### 3. Sincronização na Nuvem
```dart
Future<void> syncFavoritesCloud() async {
  await firestore
    .collection('users')
    .doc(userId)
    .set({'acoesPreferidas': _acoesPreferidas});
}
```

---

## Testes

### Teste 1: Adicionar Favorita
```
1. Abrir dropdown
2. Clicar em estrela de 'Anestro'
3. Verificar: estrela fica preenchida
4. Reabrir app
5. Verificar: 'Anestro' continua como favorita
```

### Teste 2: Remover Favorita
```
1. Abrir dropdown
2. Clicar em estrela preenchida de 'Cio'
3. Verificar: estrela fica vazia
4. Reabrir app
5. Verificar: 'Cio' não aparece como favorita
```

### Teste 3: Ordenação
```
1. Adicionar 3 favoritas: 'Cio', 'Inseminação', 'Aborto'
2. Abrir dropdown
3. Verificar: aparecem no topo na ordem: 
   - Aborto ★
   - Cio ★
   - Inseminação ★
   - (outras em ordem alfabética)
```

---

**Versão**: 1.0
**Data**: 20 de janeiro de 2026
**Status**: ✅ Implementado e Testado
