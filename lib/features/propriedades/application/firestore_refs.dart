import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/objectbox/entities/index.dart';

/// Reconstrói os `DocumentReference` do Firestore a partir das entidades do
/// ObjectBox. As telas de destino (início, edição, nova, excluídas) recebem
/// `uidTecnico`/`uidPropriedade` como `DocumentReference` pelos parâmetros de
/// rota, então a UI passa a ler do ObjectBox sem que nenhuma rota mude.
extension TecnicoDocRef on TecnicoEntity {
  /// `tecnico/{firestoreId}`.
  DocumentReference? get docRef => firestoreId == null
      ? null
      : FirebaseFirestore.instance.collection('tecnico').doc(firestoreId);
}

extension PropriedadeDocRef on PropriedadeEntity {
  /// `tecnico/{id}/propriedades/{id}`. É `null` enquanto a propriedade estiver
  /// pendente de ativação (criada offline, ainda sem documento no Firestore).
  DocumentReference? get docRef => (firestoreId == null || parentPath == null)
      ? null
      : FirebaseFirestore.instance.doc('$parentPath/propriedades/$firestoreId');
}
