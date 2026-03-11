# 🔧 Guia: Rodar App em Modo Debug no Mac

## 📋 Informações do Projeto
- **Nome do App**: Tecmuu
- **Bundle ID iOS**: br.app.tecmuu
- **Package Android**: br.app.tecmuu

---

## ✅ Pré-requisitos

### 1. Flutter SDK
```bash
# Verificar instalação
flutter --version

# Verificar ambiente
flutter doctor
```

### 2. Xcode (para iOS)
- Instalar via App Store
- Abrir Xcode pelo menos uma vez para aceitar licenças
```bash
sudo xcodebuild -license accept
```

### 3. Android Studio (para Android)
- Instalar Android Studio
- Configurar Android SDK
- Criar emulador ou conectar dispositivo físico

### 4. VS Code (Opcional, mas recomendado)
- Instalar extensões: Flutter, Dart

---

## 🚀 Comandos Rápidos

### Rodar no iOS Simulator
```bash
cd /Users/tecmuu/Desktop/tecmuu

# Listar simuladores disponíveis
flutter devices

#Inicia o Simula Iphone 14
xcrun simctl boot "iPhone 14 (iOS 26.2)" 2>&1 || echo "Tentando iniciar..."

#abre os Simuladores
open -a Simulator

# Rodar no simulador iOS padrão
flutter run

# Rodar em simulador específico
flutter run -d "iPhone 14 (iOS 26.2)"
```

### Rodar no Android Emulator
```bash
cd /Users/tecmuu/Desktop/tecmuu

# Listar emuladores
flutter emulators

# Iniciar emulador específico
flutter emulators --launch <emulator_id>

# Rodar no Android
flutter run -d android
```

### Rodar em Dispositivo Físico
```bash
# iPhone conectado via USB
flutter run -d <device_id>

# Ver dispositivos conectados
flutter devices
```

---

## 🔄 Passo a Passo Completo

### Passo 1: Preparar o Projeto
```bash
cd /Users/tecmuu/Desktop/tecmuu

# Limpar cache
flutter clean

# Baixar dependências
flutter pub get
```

### Passo 2: Preparar iOS (se necessário)
```bash
cd ios
pod install --repo-update
cd ..
```

### Passo 3: Abrir Simulador iOS
```bash
# Abrir Simulator app
open -a Simulator

# Ou via linha de comando - listar dispositivos
xcrun simctl list devices

# Iniciar simulador específico
xcrun simctl boot "iPhone 15 Pro"
```

### Passo 4: Executar o App
```bash
# Modo debug padrão (com hot reload)
flutter run

# Modo debug com logs detalhados
flutter run -v

# Modo profile (para análise de performance)
flutter run --profile
```

---

## ⌨️ Comandos Durante Execução

Enquanto o app está rodando no terminal:

| Tecla | Ação |
|-------|------|
| `r` | Hot Reload (atualiza alterações de código) |
| `R` | Hot Restart (reinicia o app mantendo estado) |
| `h` | Ajuda (lista todos os comandos) |
| `d` | Detach (desconecta mas mantém app rodando) |
| `c` | Limpa a tela |
| `q` | Quit (encerra o app) |
| `p` | Toggle debug paint |
| `o` | Alterna sistema operacional (iOS/Android) |
| `s` | Screenshot |
| `w` | Dump widget hierarchy |

---

## 🖥️ Usando VS Code

### 1. Abrir Projeto
```bash
code /Users/tecmuu/Desktop/tecmuu
```

### 2. Selecionar Dispositivo
- Clique no dispositivo no canto inferior direito
- Ou: `Cmd + Shift + P` → "Flutter: Select Device"

### 3. Iniciar Debug
- Pressione `F5` ou
- Menu: Run → Start Debugging
- Ou clique em "Run and Debug" na barra lateral

### 4. Configurar launch.json (Opcional)
Criar arquivo `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Tecmuu Debug",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": []
    },
    {
      "name": "Tecmuu Debug (verbose)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": ["-v"]
    }
  ]
}
```

---

## 🔍 Debug com DevTools

### Abrir Flutter DevTools
```bash
# Durante execução do app
flutter run

# Em outro terminal
flutter pub global activate devtools
flutter pub global run devtools
```

Ou durante execução, pressione `d` e acesse a URL mostrada.

### Recursos do DevTools:
- **Widget Inspector**: Visualizar árvore de widgets
- **Timeline**: Análise de performance
- **Memory**: Uso de memória
- **Network**: Requisições HTTP
- **Logging**: Logs do app

---

## 🛠️ Solução de Problemas

### Flutter doctor mostra erros
```bash
flutter doctor -v
```
Siga as instruções para cada item com ❌ ou ⚠️

### Simulador não aparece
```bash
# Resetar Xcode command line tools
sudo xcode-select --reset

# Reinstalar simuladores
xcrun simctl delete unavailable
```

### Erro "CocoaPods not installed"
```bash
sudo gem install cocoapods
pod setup
```

### Erro de dependências
```bash
flutter clean
flutter pub get
cd ios && pod install --repo-update && cd ..
```

### App não conecta ao Firebase
- Verificar se `google-services.json` (Android) está em `android/app/`
- Verificar se `GoogleService-Info.plist` (iOS) está em `ios/Runner/`

### Hot Reload não funciona
- Verifique se não há erros de compilação
- Tente Hot Restart (`R` maiúsculo)
- Reinicie o app completamente (`q` e `flutter run`)

### Dispositivo não aparece
```bash
# Para iOS
flutter devices

# Para Android - verificar ADB
adb devices

# Reiniciar ADB
adb kill-server && adb start-server
```

---

## 📱 Testar em Dispositivo Físico

### iPhone/iPad
1. Conecte via USB
2. Confie no computador quando solicitado
3. No Xcode: **Window → Devices and Simulators**
4. Verifique se o dispositivo aparece
5. Execute:
```bash
flutter run -d <device_id>
```

### Android
1. Ativar **Opções do Desenvolvedor** no dispositivo
2. Ativar **Depuração USB**
3. Conectar via USB
4. Aceitar permissão de debug
5. Execute:
```bash
flutter run -d <device_id>
```

---

## 🔄 Workflow Diário Recomendado

```bash
# 1. Navegar para o projeto
cd /Users/tecmuu/Desktop/tecmuu

# 2. Puxar alterações (se usar Git)
git pull

# 3. Atualizar dependências
flutter pub get

# 4. Rodar o app
flutter run

# 5. Desenvolver com Hot Reload (pressione 'r' para atualizar)
```

---

## 📊 Comandos Úteis

```bash
# Ver todos os dispositivos
flutter devices

# Ver emuladores disponíveis
flutter emulators

# Verificar ambiente
flutter doctor -v

# Limpar projeto
flutter clean

# Atualizar dependências
flutter pub get

# Atualizar pods iOS
cd ios && pod install --repo-update && cd ..

# Build apenas (sem rodar)
flutter build ios --debug
flutter build apk --debug

# Rodar testes
flutter test

# Analisar código
flutter analyze
```

---

## 🎯 Atalhos de Teclado VS Code

| Atalho | Ação |
|--------|------|
| `F5` | Iniciar Debug |
| `Shift + F5` | Parar Debug |
| `Ctrl + F5` | Rodar sem Debug |
| `F10` | Step Over |
| `F11` | Step Into |
| `Shift + F11` | Step Out |
| `Cmd + Shift + P` | Command Palette |

---

**Última atualização**: Março 2026
