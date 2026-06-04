# 🔧 Guia de Resolução: Firebase Auth Network Error

## Problema
```
FirebaseAuthException ([firebase_auth/network-request-failed] 
A network error (such as timeout, interrupted connection or unreachable host) has occurred.)
```

---

## 🔍 Causas Comuns

### 1. **Sem Conexão de Internet**
- Dispositivo desconectado do Wi-Fi/dados móveis
- Sinal de internet fraco
- Modo avião ativado

### 2. **Timeout na Conexão**
- Servidor Firebase inacessível
- Conexão muito lenta
- Firewall bloqueando requisições

### 3. **Problema de Configuração**
- Firebase não inicializado corretamente
- Credenciais inválidas
- Projeto Firebase não configurado

### 4. **Problema de SSL/TLS**
- Certificado SSL inválido ou expirado
- Clock do dispositivo dessincronizado

---

## ✅ Soluções Implementadas

### 1. **Sistema de Retry Automático com Backoff Exponencial**

```dart
// O código tenta novamente com delay crescente:
// Tentativa 1: Falha → aguarda 500ms
// Tentativa 2: Falha → aguarda 1s
// Tentativa 3: Falha → aguarda 2s
// Tentativa 4: Falha → retorna erro
```

**Arquivo:** `lib/auth/firebase_auth/email_auth.dart`

- ✅ Até 3 tentativas automáticas
- ✅ Backoff exponencial (500ms → 1s → 2s)
- ✅ Timeout de 30 segundos por operação
- ✅ Verifica conectividade antes de cada tentativa

### 2. **Validação de Conectividade**

```dart
Future<bool> _hasNetworkConnection() async {
  // Verifica status de conectividade
  // Tenta resolver DNS (8.8.8.8)
  // Timeout de 3 segundos
}
```

**Detecta:**
- Sem conexão disponível
- Host inacessível
- DNS não resolvendo

### 3. **Tratamento Detalhado de Erros**

```dart
// Arquivo: lib/auth/firebase_auth/firebase_config.dart
FirebaseAuthConfig.getErrorMessage(exception)
```

**Mensagens customizadas para:**
- Erros de rede (connection failed, timeout)
- Erros de email (inválido, já registrado)
- Erros de senha (fraca, incorreta)
- Rate limiting (muitas tentativas)

### 4. **Logging Detalhado**

```
🔄 Tentativa 1 de 3 após erro: network-request-failed
🔄 Tentativa 2 de 3 após timeout
❌ Erro de autenticação: weak-password
✅ Usuário restaurado: user@example.com
```

---

## 📱 Como Usar no Seu Código

### Ao Fazer Login:

```dart
try {
  final userCredential = await emailSignInFunc(
    email,
    password,
  );
  // Sucesso! Retry automático foi usado se necessário
} on FirebaseAuthException catch (e) {
  // Mensagem de erro já tratada e amigável
  final message = FirebaseAuthConfig.getErrorMessage(e);
  showErrorSnackBar(context, message);
}
```

### Ao Criar Conta:

```dart
try {
  final userCredential = await emailCreateAccountFunc(
    email,
    password,
  );
  // Sucesso! 
} catch (e) {
  // Erro tratado com mensagem clara
  final message = FirebaseAuthConfig.getDetailedErrorMessage(e);
  showDialog(context, title: 'Erro', message: message);
}
```

### Inicializar Firebase Auth:

```dart
// No main.dart ou no initState:
await FirebaseAuthConfig.initialize();
```

---

## 🛠️ Configuração do Firebase (Android)

### 1. **Adicionar Permissões (AndroidManifest.xml)**

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 2. **Configurar timeouts no build.gradle**

```gradle
android {
    compileSdkVersion 35
    
    defaultConfig {
        targetSdkVersion 35
        minSdkVersion 23
        
        // Adicionar configuração de timeout
        testInstrumentationRunnerArguments(
            "verboseLogging": "true"
        )
    }
}
```

### 3. **Adicionar SSL/TLS Certificates**

Se tiver problema com certificados, adicione em `android/app/src/main/AndroidManifest.xml`:

```xml
<domain-config cleartextTrafficPermitted="false">
    <domain includeSubdomains="true">firebaseio.com</domain>
    <domain includeSubdomains="true">googleapis.com</domain>
</domain-config>
```

---

## 🧪 Teste de Conectividade

### Teste Local:

```dart
// Adicione este código em um botão de debug:
void _testConnectivity() async {
  try {
    final hasConnection = await _hasNetworkConnection();
    print('Conexão: $hasConnection');
    
    // Tenta login
    await emailSignInFunc('test@test.com', 'password123');
    print('✅ Login bem-sucedido!');
  } on FirebaseAuthException catch (e) {
    print('❌ ${FirebaseAuthConfig.getErrorMessage(e)}');
  }
}
```

### Simular Falha de Rede:

```dart
// Modo avião: ativa/desativa em tempo real
// Desconectar Wi-Fi: testa fallback para dados móveis
// Usar Charles/Fiddler: intercepte e bloqueie requisições
```

---

## 📊 Fluxo de Execução com Tratamento de Erros

```
┌─────────────────────────┐
│  emailSignInFunc()      │
└────────────┬────────────┘
             │
             ├─ Verifica conexão? ❌ → Erro: network-unavailable
             │
             ├─ Tenta signInWithEmailAndPassword()
             │    ├─ ✅ Sucesso! → Retorna UserCredential
             │    │
             │    └─ ❌ Erro de rede
             │         ├─ Tentativa 1: Aguarda 500ms
             │         ├─ Tentativa 2: Aguarda 1s
             │         ├─ Tentativa 3: Aguarda 2s
             │         └─ ❌ Falha → Retorna FirebaseAuthException
             │
             └─ FirebaseAuthConfig.getErrorMessage()
                  → Mensagem amigável ao usuário
```

---

## 🔐 Segurança Recomendada

### 1. **Nunca Expor Tokens**
```dart
// ❌ Errado
print('Token: ${user.getIdToken()}');

// ✅ Correto
final token = await user.getIdToken();
// Use em requisições HTTP apenas
```

### 2. **Validar Email e Senha**
```dart
if (!FirebaseAuthConfig.isValidEmail(email)) {
  showError('Email inválido');
  return;
}

if (!FirebaseAuthConfig.isValidPassword(password)) {
  showError('Senha deve ter no mínimo 6 caracteres');
  return;
}
```

### 3. **Limpar Dados Sensíveis**
```dart
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}
```

---

## 📋 Checklist de Debug

- [ ] Conexão de internet ativa?
- [ ] Firebase Console acessível?
- [ ] Google Play Services atualizado?
- [ ] Certificados SSL válidos?
- [ ] Permissões no AndroidManifest.xml?
- [ ] Firebase inicializado antes de usar?
- [ ] Email e senha válidos?
- [ ] Usuário não excedeu limite de tentativas?
- [ ] Clock do dispositivo sincronizado?
- [ ] Firewall não bloqueando googleapis.com?

---

## 🐛 Logs para Debugging

### Ver logs detalhados:

```bash
# Terminal
adb logcat | grep -i firebase

# Ou no seu código
debugPrintSynchronously: true
```

### Exemplo de log esperado:

```
▶️ Iniciando: Sign In (tentativa 1/3)
🔄 Retry 1 após erro de rede: network-request-failed
▶️ Iniciando: Sign In (tentativa 2/3)
✅ Usuário restaurado: user@example.com
```

---

## 📞 Se o Problema Persistir

1. **Verifique logs detalhados:**
   ```bash
   flutter run -v 2>&1 | grep -i firebase
   ```

2. **Teste conectividade básica:**
   ```bash
   ping 8.8.8.8
   curl https://www.google.com
   ```

3. **Reinicie o emulador/dispositivo**

4. **Limpe cache e rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

5. **Contacte suporte Firebase:**
   - https://firebase.google.com/support
   - Forneça: código do erro, logs, versão do app

---

## 📚 Referências

- [Firebase Auth Docs](https://firebase.google.com/docs/auth)
- [Flutter Connectivity Plus](https://pub.dev/packages/connectivity_plus)
- [Firebase Error Codes](https://firebase.google.com/docs/auth/errors)
- [Network Error Handling](https://dart.dev/guides/libraries/library-tour#dartasync-await-and-futures)

---

**Último update:** 1 de junho de 2026
**Status:** ✅ Resolvido com retry automático e tratamento de erros
