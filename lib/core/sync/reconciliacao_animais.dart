import '../../data/objectbox/entities/index.dart';

/// Documento do Firestore reduzido ao que a reconciliacao precisa. Existe para
/// a regra ser testavel sem Firestore em runtime.
class DocAnimal {
  const DocAnimal(this.firestoreId, this.data);
  final String firestoreId;
  final Map<String, dynamic> data;
}

/// Decide, para cada doc baixado, se ele atualiza um animal ja existente ou
/// entra como novo, devolvendo a lista pronta para um unico `putMany`.
///
/// Preservar o `id` local do registro existente e o que impede a insercao
/// duplicada que viola o indice unico de `firestoreId` no segundo download
/// completo do aparelho.
List<AnimalEntity> reconciliarAnimais({
  required List<DocAnimal> docs,
  required Map<String, AnimalEntity> existentesPorFirestoreId,
  required String parentPath,
}) {
  final resultado = <AnimalEntity>[];

  for (final doc in docs) {
    final existente = existentesPorFirestoreId[doc.firestoreId];
    if (existente != null) {
      existente.updateFromFirestore(doc.data);
      resultado.add(existente);
    } else {
      resultado.add(
        AnimalEntity.fromFirestore(doc.data, doc.firestoreId, parentPath),
      );
    }
  }

  return resultado;
}
