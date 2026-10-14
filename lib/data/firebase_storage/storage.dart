import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mime_type/mime_type.dart';

/// Envia [data] para [path] no Storage e devolve a URL de download, ou `null`
/// se o envio falhar.
///
/// Falha vira `null` em vez de exceção: os chamadores (assinaturas do
/// receituário) já tratam `null` com "Envio de dados falhou". Enquanto a
/// exceção escapava, o snackbar "Seus dados estão sendo enviados..." girava
/// para sempre e a tela ficava presa.
Future<String?> uploadData(String path, Uint8List data) async {
  try {
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final metadata = SettableMetadata(contentType: mime(path));
    final result = await storageRef.putData(data, metadata);
    return result.state == TaskState.success
        ? await result.ref.getDownloadURL()
        : null;
  } on FirebaseException catch (e) {
    // O caminho e o usuário autenticado são o que decide a regra do Storage
    // (users/{userId}/** só aceita escrita do próprio userId).
    debugPrint('❌ Storage recusou o envio (${e.code}): path=$path '
        'authUid=${FirebaseAuth.instance.currentUser?.uid ?? 'NULO'}');
    return null;
  }
}
