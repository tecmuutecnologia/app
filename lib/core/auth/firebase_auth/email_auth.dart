import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:io';

/// Verifica a conectividade de rede disponível
Future<bool> _hasNetworkConnection() async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();

    // Verifica se há alguma conexão disponível
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Tenta fazer uma verificação adicional com timeout
    try {
      final result = await InternetAddress.lookup('8.8.8.8')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  } catch (_) {
    return false;
  }
}

/// Faz retry automático da função com backoff exponencial
Future<T> _executeWithRetry<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
  Duration initialDelay = const Duration(milliseconds: 500),
}) async {
  int attempt = 0;
  Duration delay = initialDelay;

  while (true) {
    try {
      // Verifica conectividade antes de cada tentativa
      final hasConnection = await _hasNetworkConnection();
      if (!hasConnection) {
        throw FirebaseAuthException(
          code: 'network-unavailable',
          message:
              'Nenhuma conexão de rede disponível. Verifique sua internet.',
        );
      }

      // Tenta executar a operação
      return await operation().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw FirebaseAuthException(
            code: 'network-request-timeout',
            message: 'Tempo limite de conexão excedido. Tente novamente.',
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Se é um erro de rede/timeout e ainda temos tentativas, tenta novamente
      if ((e.code == 'network-request-failed' ||
              e.code == 'network-request-timeout' ||
              e.code == 'network-unavailable') &&
          attempt < maxRetries) {
        attempt++;
        print('🔄 Tentativa $attempt de $maxRetries após erro: ${e.code}');

        // Aguarda com backoff exponencial
        await Future.delayed(delay);
        delay = Duration(milliseconds: delay.inMilliseconds * 2);

        continue;
      }

      // Se foi o último erro ou não é erro de rede, relança
      rethrow;
    } catch (e) {
      // Para outros tipos de erro (ex: TimeoutException, SocketException)
      if (attempt < maxRetries && e.toString().contains('SocketException')) {
        attempt++;
        print('🔄 Tentativa $attempt de $maxRetries após erro de socket');

        await Future.delayed(delay);
        delay = Duration(milliseconds: delay.inMilliseconds * 2);

        continue;
      }

      // Se é timeout e ainda temos tentativas
      if (attempt < maxRetries && e is TimeoutException) {
        attempt++;
        print('🔄 Tentativa $attempt de $maxRetries após timeout');

        await Future.delayed(delay);
        delay = Duration(milliseconds: delay.inMilliseconds * 2);

        continue;
      }

      // Erros que não são de rede não são retentados
      rethrow;
    }
  }
}

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
    print('❌ Erro de autenticação: ${e.code} - ${e.message}');
    rethrow;
  }
}

Future<UserCredential?> emailCreateAccountFunc(
  String email,
  String password,
) async {
  try {
    return await _executeWithRetry<UserCredential?>(
      () => FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
      maxRetries: 3,
    );
  } on FirebaseAuthException catch (e) {
    print('❌ Erro ao criar conta: ${e.code} - ${e.message}');
    rethrow;
  }
}
