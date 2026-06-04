import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

/// Configurações e utilidades para Firebase Auth
class FirebaseAuthConfig {
  /// Timeout padrão para operações Firebase
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Máximo de tentativas para operações com falha de rede
  static const int maxRetries = 3;

  /// Delay inicial para retry com backoff exponencial
  static const Duration initialRetryDelay = Duration(milliseconds: 500);

  /// Inicializa configurações do Firebase Auth
  static Future<void> initialize() async {
    // Ativa o seguimento detalhado de logs em desenvolvimento
    if (kDebugMode) {
      FirebaseAuth.instance.setLanguageCode('pt_BR');
      print('🔧 Firebase Auth configurado com idioma: pt_BR');
    }

    // Configura timeouts personalizados
    FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: kDebugMode,
    );

    // Tenta restaurar a sessão do usuário
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('✅ Usuário restaurado: ${user.email}');

        // Atualiza o token JWT
        await user.getIdToken();
      }
    } catch (e) {
      print('⚠️ Erro ao restaurar sessão: $e');
    }
  }

  /// Trata e formata mensagens de erro do Firebase Auth
  static String getErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      // Erros de rede
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet e tente novamente.';
      case 'network-request-timeout':
        return 'Tempo limite de conexão excedido. Tente novamente.';
      case 'network-unavailable':
        return 'Nenhuma conexão de rede disponível. Ative a internet.';

      // Erros de email
      case 'invalid-email':
        return 'Email inválido. Verifique o endereço.';
      case 'email-already-in-use':
        return 'Este email já está registrado.';
      case 'user-not-found':
        return 'Email não encontrado. Verifique ou crie uma conta.';

      // Erros de senha
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'weak-password':
        return 'Senha fraca. Use pelo menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Operação não permitida. Contate o suporte.';

      // Erros de rate limit
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde alguns minutos.';

      // Outros erros
      default:
        return exception.message ?? 'Erro desconhecido. Tente novamente.';
    }
  }

  /// Valida um email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Valida uma senha
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Obtém a mensagem de erro detalhada
  static String getDetailedErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return getErrorMessage(error);
    } else if (error is TimeoutException) {
      return 'Operação expirou. Verifique sua conexão.';
    } else {
      return error.toString();
    }
  }
}

/// Wrapper para operações Firebase com tratamento de erro
class FirebaseAuthOperation<T> {
  final Future<T> Function() operation;
  final String operationName;
  final int maxRetries;
  final Duration retryDelay;

  FirebaseAuthOperation({
    required this.operation,
    required this.operationName,
    this.maxRetries = FirebaseAuthConfig.maxRetries,
    this.retryDelay = FirebaseAuthConfig.initialRetryDelay,
  });

  Future<T> execute() async {
    int attempt = 0;
    Duration currentDelay = retryDelay;

    while (true) {
      try {
        print(
            '▶️ Iniciando: $operationName (tentativa ${attempt + 1}/$maxRetries)');

        return await operation().timeout(
          FirebaseAuthConfig.defaultTimeout,
          onTimeout: () => throw TimeoutException(
            'Timeout em $operationName',
            FirebaseAuthConfig.defaultTimeout,
          ),
        );
      } on FirebaseAuthException catch (e) {
        final isNetworkError = e.code == 'network-request-failed' ||
            e.code == 'network-request-timeout' ||
            e.code == 'network-unavailable';

        if (isNetworkError && attempt < maxRetries - 1) {
          attempt++;
          print('🔄 Retry $attempt após erro de rede: ${e.code}');
          await Future.delayed(currentDelay);
          currentDelay = Duration(
            milliseconds: currentDelay.inMilliseconds * 2,
          );
          continue;
        }

        print('❌ Falha em $operationName: ${e.code} - ${e.message}');
        rethrow;
      } catch (e) {
        print('❌ Erro inesperado em $operationName: $e');
        rethrow;
      }
    }
  }
}
