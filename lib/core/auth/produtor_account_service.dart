import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Cria a conta do produtor (Firebase Auth + doc `person`) SEM afetar a sessão
/// do técnico logado.
///
/// O `createUserWithEmailAndPassword` na instância primária do Firebase troca a
/// sessão para o novo usuário (deslogando o técnico). Para evitar isso — e assim
/// dispensar guardar/repetir a senha do técnico — usamos uma instância
/// SECUNDÁRIA e isolada do Firebase App: a conta é criada nela e a instância é
/// descartada em seguida. A sessão primária (técnico) nunca é tocada.
class ProdutorAccountService {
  const ProdutorAccountService._();

  /// Cria a conta do produtor (Auth) na instância secundária e grava o doc
  /// `person/{uid}` na instância PRIMÁRIA (como o técnico logado) — mesmo padrão
  /// do resto do app (`PersonRecord.collection`). A secundária serve só para não
  /// deslogar o técnico ao criar a conta; ela não deve tocar no Firestore.
  ///
  /// [buildPersonData] recebe o `uid` recém-criado e devolve o mapa a gravar
  /// (normalmente `createPersonRecordData(uid: uid, ...)`).
  ///
  /// Retorna o `uid` do produtor criado. Lança [FirebaseAuthException] em caso
  /// de e-mail já em uso, senha fraca etc. — tratado pelo chamador.
  static Future<String> criarContaProdutor({
    required String email,
    required String password,
    required Map<String, dynamic> Function(String uid) buildPersonData,
  }) async {
    // Nome único evita colisão com uma instância órfã de uma tentativa anterior.
    final appName = 'produtorCreator_${DateTime.now().microsecondsSinceEpoch}';
    FirebaseApp? secondaryApp;
    try {
      secondaryApp = await Firebase.initializeApp(
        name: appName,
        options: Firebase.app().options,
      );

      final auth = FirebaseAuth.instanceFor(app: secondaryApp);
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;

      // Grava o person na instância PRIMÁRIA (técnico) — mesmo padrão do resto
      // do app (PersonRecord.collection). A secundária serve SÓ para criar a
      // conta Auth sem deslogar o técnico; ela não deve tocar no Firestore.
      await FirebaseFirestore.instance
          .collection('person')
          .doc(uid)
          .set(buildPersonData(uid));

      return uid;
    } finally {
      await secondaryApp?.delete();
    }
  }
}
