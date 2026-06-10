import 'package:firebase_auth/firebase_auth.dart';

/// Fonte de verdade do estado de autenticação para a camada nova consumir via
/// provider, em vez dos getters globais mutáveis (`currentUserUid`,
/// `currentUser`, ...) espalhados pelo código FlutterFlow em `auth_util.dart`.
///
/// É lógica fina sobre o `FirebaseAuth`: expõe o usuário/uid/email atuais e um
/// stream reativo das mudanças de sessão (login/logout/refresh). NÃO substitui
/// o fluxo de login (que segue em `email_auth`/`firebase_auth_manager` +
/// `OfflineAuthService`); centraliza apenas a LEITURA do estado, para reduzir o
/// acoplamento das telas novas aos globais mutáveis.
class AuthRepository {
  AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Emite o usuário corrente a cada login/logout (e `null` quando deslogado).
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  String? get uid => _auth.currentUser?.uid;

  String? get email => _auth.currentUser?.email;

  bool get isAuthenticated => _auth.currentUser != null;
}
