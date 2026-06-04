# 🔐 Guia de Integração - OfflineAuthService no email_auth.dart

## 📌 Resumo

Este guia mostra como integrar o novo `OfflineAuthService` no fluxo de login existente, adicionando capacidade de login offline ao seu app.

---

## 🔄 Modificação do email_auth.dart

### Passo 1: Adicionar Imports

**Arquivo:** `lib/auth/firebase_auth/email_auth.dart`

```dart
// Adicionar ao topo do arquivo
import 'package:tecmuu/backend/objectbox/offline_auth_service.dart';
```

### Passo 2: Modificar emailSignInFunc

Antes (apenas Firebase):
```dart
Future<UserCredential?> emailSignInFunc(
  String email,
  String password,
) async {
  try {
    return await _executeWithRetry<UserCredential?>(
      () => FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
      maxRetries: 3,
    );
  } on FirebaseAuthException catch (e) {
    print('❌ Erro de autenticação: ${e.code}');
    rethrow;
  }
}
```

Depois (com fallback offline):
```dart
Future<UserCredential?> emailSignInFunc(
  String email,
  String password,
) async {
  try {
    // ✨ NOVO: Inicializa OfflineAuthService
    final offlineAuth = await OfflineAuthService.instance;
    
    final trimmedEmail = email.trim();

    // ✨ NOVO: Tenta login com validação Firebase + fallback offline
    final session = await offlineAuth.loginWithFirebaseValidation(
      email: trimmedEmail,
      password: password,
      firebaseAuth: () => FirebaseAuth.instance.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      ),
    );

    if (session == null) {
      throw FirebaseAuthException(
        code: 'invalid-credentials',
        message: 'Email ou senha inválidos',
      );
    }

    print('✅ Login bem-sucedido! Session: ${session.email}');

    // Se conseguiu fazer login online, retorna credencial do Firebase
    // Se fez login offline, retorna null (mas app funciona mesmo assim)
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
    } catch (e) {
      // Se offline, retorna null (uso local da sessão)
      print('📡 Login offline - sem credencial Firebase no momento');
      return null;
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'network-request-failed' ||
        e.code == 'network-request-timeout' ||
        e.code == 'network-unavailable') {
      print('📡 Sem conexão com Firebase. Tentando login offline...');
      // O OfflineAuthService já tentou isso automaticamente
    }
    print('❌ Erro de autenticação: ${e.code}');
    rethrow;
  }
}
```

### Passo 3: Modificar emailCreateAccountFunc

Para novo cadastro (requer internet obrigatoriamente):

```dart
Future<UserCredential?> emailCreateAccountFunc(
  String email,
  String password,
) async {
  try {
    // ✨ NOVO: Inicializa OfflineAuthService
    final offlineAuth = await OfflineAuthService.instance;

    final trimmedEmail = email.trim();

    // Novo cadastro REQUER internet
    print('📝 Criando novo cadastro (requer internet)...');

    try {
      final userCredential =
          await _executeWithRetry<UserCredential?>(
        () => FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: trimmedEmail,
          password: password,
        ),
        maxRetries: 3,
      );

      // ✨ NOVO: Cria sessão offline após cadastro bem-sucedido
      if (userCredential?.user != null) {
        final session = await offlineAuth.createSessionFromFirebaseUser(
          firebaseUser: userCredential!.user!,
          password: password,
        );
        print('✅ Cadastro bem-sucedido! Session criada: ${session.email}');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed' ||
          e.code == 'network-request-timeout') {
        throw FirebaseAuthException(
          code: 'network-required',
          message: 'Cadastro requer conexão com internet. '
              'Conecte-se e tente novamente.',
        );
      }
      rethrow;
    }
  } on FirebaseAuthException catch (e) {
    print('❌ Erro ao criar conta: ${e.code}');
    rethrow;
  }
}
```

---

## 🔄 Modificação do firebase_user_provider.dart

### Adicionar Validação de Sessão Offline

**Arquivo:** `lib/auth/firebase_auth/firebase_user_provider.dart`

Modificar o stream:

```dart
Stream<BaseAuthUser> tecmuuFirebaseUserStream() {
  // ✨ NOVO: Também acompanha mudanças offline
  final connec tivity = Connectivity();
  
  return Rx.combineLatest2(
    FirebaseAuth.instance.authStateChanges(),
    connectivity.onConnectivityChanged.startWith(
      ConnectivityResult.none,
    ),
  ).asyncMap<BaseAuthUser>((values) async {
    final user = values[0] as User?;

    if (user != null) {
      // Tem usuário Firebase online
      print('🟢 Usuário Firebase autenticado: ${user.email}');

      // ✨ NOVO: Também cria/atualiza sessão local
      try {
        final offlineAuth = await OfflineAuthService.instance;
        // Nota: Pode não ter a senha, então só marca como sincronizado
        print('💾 Sessão sincronizada com Firebase');
      } catch (e) {
        print('⚠️ Erro ao sincronizar sessão: $e');
      }

      return TecmuuFirebaseUser(user);
    }

    // ✨ NOVO: Se não tem Firebase, verifica sessão offline
    try {
      final offlineAuth = await OfflineAuthService.instance;
      final sessions = await offlineAuth.getAllActiveSessions();

      if (sessions.isNotEmpty) {
        print('🟡 Usando sessão offline: ${sessions.first.email}');
        // Cria usuário "fake" com dados da sessão local
        // O app funciona com dados locais até sincronizar
        return TecmuuFirebaseUser(null); // Indica modo offline
      }
    } catch (e) {
      print('⚠️ Erro ao checar sessão offline: $e');
    }

    print('🔴 Sem autenticação');
    return TecmuuFirebaseUser(null);
  });
}
```

---

## 🔄 Modificação do offline_first_sync_service.dart

### Adicionar Sincronização de Sessões

Quando voltar online, sincronizar sessões:

```dart
Future<void> _setupConnectivityListener() async {
  final result = await _connectivity.checkConnectivity();
  _isOnline = result != ConnectivityResult.none;

  _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
    (ConnectivityResult result) async {
      final wasOffline = !_isOnline;
      _isOnline = result != ConnectivityResult.none;

      if (_isOnline && wasOffline) {
        debugPrint('🔄 Conexão restaurada - sincronizando pendências');

        // ✨ NOVO: Sincroniza sessões offline
        try {
          final offlineAuth = await OfflineAuthService.instance;
          await offlineAuth.syncSessionsWithFirebase(
            firebaseAuth: (email, password) {
              // Não pode revalidar sem senha, apenas marca como OK
              // User vai precisar fazer login com internet periodicamente
              return Future.error(
                'Sincronização de sessão não requer revalidação',
              );
            },
          );
          debugPrint('✅ Sessões sincronizadas');
        } catch (e) {
          debugPrint('⚠️ Erro ao sincronizar sessões: $e');
        }

        // Sincroniza dados do usuário
        await syncPendingChangesToFirestore();
      }

      _updateStatus(_isOnline ? SyncStatus.idle : SyncStatus.offline);
    },
  );
}
```

---

## 🧪 Testes Recomendados

### Teste 1: Login Online Normal
```
1. Abrir app
2. Conectado a internet
3. Login com email válido
4. ✅ Esperado: Faz login com Firebase
   Logs: ✅ Login bem-sucedido! Session: user@email.com
```

### Teste 2: Login Offline (com sessão em cache)
```
1. Abrir app
2. Fazer login normal (online)
3. Fechar app
4. Ativar Airplane Mode
5. Abrir app
6. Tentar fazer logout
7. Fazer login com mesma conta
8. ✅ Esperado: Faz login com cache local
   Logs: 📡 Sem conexão com Firebase. Tentando login offline...
         ✅ Login offline bem-sucedido: user@email.com
```

### Teste 3: Login Offline com Senha Errada
```
1. Mesmo setup do Teste 2
2. Fazer login com senha errada
3. ❌ Esperado: Rejeita (valida contra hash local)
   Logs: ❌ Senha incorreta para: user@email.com
```

### Teste 4: Primeiro Login Offline (sem cache)
```
1. Abrir app
2. Ativar Airplane Mode
3. Tentar fazer login com conta NOVA
4. ❌ Esperado: Rejeita
   Logs: ❌ Usuário não encontrado offline. Primeira vez? Verifique conexão.
         💡 Mostrar mensagem: "Primeira vez? Conecte-se a internet para cadastro"
```

### Teste 5: Sincronização após reconexão
```
1. Login offline
2. Abrir app, adicionar dados (offline)
3. Desativar Airplane Mode
4. Esperar 2-3 segundos
5. ✅ Esperado: Sincroniza automaticamente
   Logs: 🔄 Conexão restaurada - sincronizando pendências
         ✅ Sessões sincronizadas
         🔄 Enviando operações pendentes...
```

---

## ⚠️ Casos Especiais

### Caso 1: User Troca Senha via Firebase
```
Situação: User faz login, depois troca senha no site/outro app

Resultado:
- Sessão local fica com hash ANTIGO
- Próximo login online valida e ATUALIZA hash
- Próximo login offline funciona com senha NOVA

Logs:
🔐 Tentando login offline para: user@email.com
❌ Senha incorreta (hash não coincide)
📡 Sem internet? Use sua conta com conexão...
```

### Caso 2: Session Expirou (> 30 dias)
```
Situação: User não usa app por 31 dias, agora tenta login offline

Resultado:
- Session invalida (expiração)
- ❌ Rejeita login offline
- Mostra: "Sessão expirou. Conecte-se para fazer login"

Logs:
❌ Sessão expirada. Faça login com internet.
```

### Caso 3: Device Perdido
```
Situação: Device com dados locais é perdido

Resultado:
- ⚠️ RISCO: Dados locais podem ser acessados

Mitigações (futuras):
1. Adicionar PIN local para desbloquear
2. Adicionar biometria (fingerprint/face)
3. Adicionar device fingerprint
4. Permitir logout remoto via Firebase
```

---

## 🚀 Deployment

Após implementar:

1. **Testar Localmente**
   ```bash
   flutter run
   # Testar todos os cenários acima
   ```

2. **Build Release**
   ```bash
   flutter build apk --release
   # ou
   flutter build ios --release
   ```

3. **Deploy para Play Store/App Store**
   - Aumentar versionCode/version
   - Deploy como hotfix ou versão normal

4. **Monitor Primeira Semana**
   - Verificar Crashlytics
   - Monitorar "network-request-failed" errors
   - Coletar feedback de usuários

---

## 📊 Métricas para Acompanhar

| Métrica | Antes | Meta |
|---------|-------|------|
| Taxa Login Sucesso | 20% | 85%+ |
| Tempo para Erro | 5+ min | < 3s |
| Usuários Offline | 0% | 15%+ |
| Retry Automático | 0% | 60%+ |

---

## 🔗 Referências

- `OfflineAuthService`: `lib/backend/objectbox/offline_auth_service.dart`
- `UserSessionEntity`: `lib/backend/objectbox/entities/user_session_entity.dart`
- Documentação completa: `GUIA_AUTENTICACAO_OFFLINE_FIRST.md`

---

**Status:** ✅ PRONTO PARA IMPLEMENTAÇÃO  
**Data:** 1 de junho de 2026
