# 📱 Guia de Debug - iOS e Android

Este documento explica como rodar sua aplicação Flutter em modo debug em dispositivos iOS e Android.

---

## 📲 **iOS - Simulador iPhone**

### **Método 1: Linha de Comando (Recomendado)**

#### 1️⃣ Listar simuladores disponíveis:
```bash
xcrun simctl list devices available
```

Você verá algo como:
```
== Devices ==
-- iOS 26.2 --
    iPhone 14 (62F58F48-58B6-4100-9CD5-B3BA2DC04AE0) (Shutdown)
    iPhone 15 (7A9B3C2D-1E4F-4A6B-9D2E-8F3G4H5I6J7K) (Shutdown)
```

#### 2️⃣ Rodar no simulador padrão:
```bash
flutter run
```

#### 3️⃣ Rodar em um simulador específico:
```bash
# Usando o nome
flutter run -d "iPhone 14"

# Ou usando o ID
flutter run -d "62F58F48-58B6-4100-9CD5-B3BA2DC04AE0"
```

#### 4️⃣ Se o simulador estiver desligado, boot ele primeiro:
```bash
xcrun simctl boot "62F58F48-58B6-4100-9CD5-B3BA2DC04AE0"
flutter run -d "iPhone 14"
```

---

### **Método 2: Xcode (Visual)**

```bash
# Abrir o projeto no Xcode
open ios/Runner.xcworkspace
```

Depois no Xcode:
1. Selecione o simulador em **Product → Destination**
2. Clique no botão **Play** ▶️

---

### **Troubleshooting iOS**

**Problema:** CocoaPods não instalado ou quebrado
```bash
sudo gem install cocoapods
cd ios && pod install && cd ..
```

**Problema:** Cache antigo
```bash
flutter clean
rm -rf ios/Pods ios/Podfile.lock
flutter pub get
flutter run -d "iPhone 14"
```

**Problema:** Pod install muito lento/trava
```bash
cd ios
pod install --repo-update
cd ..
flutter run -d "iPhone 14"
```

---

## 🤖 **Android - Emulador ou Dispositivo Físico**

### **Método 1: Emulador Android**

#### 1️⃣ Listar emuladores disponíveis:
```bash
emulator -list-avds
```

Você verá algo como:
```
Pixel_5_API_33
Pixel_6_API_34
Nexus_5X_API_30
```

#### 2️⃣ Iniciar um emulador:
```bash
emulator -avd Pixel_5_API_33
```

#### 3️⃣ Aguardar carregar (1-2 minutos) e rodar:
```bash
flutter run
```

#### 4️⃣ Rodar direto em um emulador específico:
```bash
emulator -avd Pixel_5_API_33 &
sleep 5
flutter run
```

---

### **Método 2: Dispositivo Físico Android**

#### 1️⃣ Conectar o celular via USB
- Ativar **Developer Mode** (toque 7x em "Build Number")
- Ativar **USB Debugging**
- Autorizar no prompt do celular

#### 2️⃣ Listar dispositivos conectados:
```bash
flutter devices
```

Você verá:
```
1 connected device:

motorola moto g100 (mobile) • 123ABC456DEF • android-arm64 • Android 12
```

#### 3️⃣ Rodar no dispositivo físico:
```bash
flutter run
```

#### 4️⃣ Rodar em um dispositivo específico:
```bash
flutter run -d "123ABC456DEF"
```

---

### **Troubleshooting Android**

**Problema:** Emulador não aparece em `flutter devices`
```bash
# Verificar ADB
flutter doctor -v

# Ou reiniciar ADB
adb kill-server
adb start-server
flutter devices
```

**Problema:** Permissão USB negada
```bash
adb kill-server
sudo adb start-server
flutter run
```

**Problema:** Gradle build fails
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🔍 **Listar Todos os Devices Disponíveis**

```bash
flutter devices
```

Saída esperada:
```
4 connected devices:

motorola moto g100 (mobile)  • 123ABC456DEF • android-arm64 • Android 12
iPhone 14 (mobile)           • 62F58F48... • ios          • iOS 26.2
macOS (desktop)              • macos       • darwin-arm64 • macOS 15.6.1
Chrome (web)                 • chrome      • web          • Google Chrome 143.0
```

---

## 🎯 **Hot Reload / Hot Restart durante Debug**

Enquanto `flutter run` está ativo:

| Comando | Atalho | Função |
|---------|--------|--------|
| Hot Reload | `r` | Recarrega o código (mantém estado) |
| Hot Restart | `R` | Reinicia completamente o app |
| Quit | `q` | Para a execução |
| Debug Info | `w` | Toggle debug painting |
| Performance | `p` | Mostra performance overlay |

---

## 📊 **Verificar Saúde do Projeto**

```bash
# Análise completa
flutter doctor

# Análise verbose
flutter doctor -v

# Verificar específico para iOS
flutter doctor --verbose | grep -A 20 "Xcode"

# Verificar específico para Android
flutter doctor --verbose | grep -A 20 "Android"
```

---

## 🚀 **Atalhos Úteis**

### iOS
```bash
# Listar todos os simuladores (incluindo offline)
xcrun simctl list devices

# Apagar um simulador antigo
xcrun simctl delete "iPhone 12"

# Resetar um simulador
xcrun simctl erase "iPhone 14"
```

### Android
```bash
# Listar todos os AVDs
emulator -list-avds

# Criar um novo emulador
avdmanager create avd -n "Pixel_7" -k "system-images;android;34;google_apis"

# Limpar cache gradle
./gradlew clean
```

---

## 💡 **Dicas Finais**

1. **iPhone**: Sempre use `xcworkspace` (não `.xcodeproj`)
2. **Android**: Mantenha o emulador aberto enquanto desenvolve
3. **Network**: Ambos emulador/simulador podem ter issues de rede - teste com IP real
4. **Performance**: Feche outros emuladores para melhor performance
5. **Cache**: Se tiver bugs estranhos, sempre execute `flutter clean` e `flutter pub get`

---

## 📞 **Referências Rápidas**

```bash
# Setup completo (quando tudo falha)
flutter clean
flutter pub get
flutter pub get --offline  # Se offline

# iOS
cd ios && pod install && cd ..
flutter run -d "iPhone 14"

# Android
flutter run  # Detecta automaticamente emulador/dispositivo

# Ambos
flutter devices                    # Lista disponíveis
flutter run -d <device-id>        # Roda em device específico
```

---
