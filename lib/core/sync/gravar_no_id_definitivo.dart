import 'package:cloud_firestore/cloud_firestore.dart';

/// Grava [payload] no documento definitivo da entidade e devolve o id dele.
///
/// Sem [firestoreId] (registro legado, anterior ao id pré-gerado), gera um no
/// cliente e o entrega a [fixarIdLocal] ANTES de gravar: se a gravação cair, a
/// próxima tentativa reusa o mesmo id em vez de inventar outro.
///
/// Substitui o `collection.add()` dos laços de sync, que criava um documento
/// novo a cada tentativa. `set(merge)` cobre também o documento que ainda não
/// existe (id pré-gerado offline), onde `update` falharia com NOT_FOUND.
Future<String> gravarNoIdDefinitivo({
  required FirebaseFirestore firestore,
  required String colecaoPath,
  required String? firestoreId,
  required Map<String, dynamic> payload,
  required void Function(String id) fixarIdLocal,
}) async {
  var id = firestoreId;
  if (id == null) {
    id = firestore.collection(colecaoPath).doc().id;
    fixarIdLocal(id);
  }
  await firestore
      .doc('$colecaoPath/$id')
      .set(payload, SetOptions(merge: true));
  return id;
}
