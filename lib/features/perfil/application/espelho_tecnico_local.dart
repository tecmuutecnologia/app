import '/data/objectbox/entities/tecnico_entity.dart';

/// Entidade local do tecnico que o cadastro acabou de criar no Firestore, ou
/// `null` quando o cache ja tem esse documento.
///
/// O app e offline-first: o dashboard le o tecnico do ObjectBox, nunca do
/// Firestore. O cadastro grava so no Firestore e conta com a sincronizacao
/// para trazer o documento de volta — mas o login logo apos o cadastro cai no
/// ramo incremental (`initial_download` ja esta marcado e o cache tem
/// animais), que nao baixa nada. Sem este espelho o tecnico so aparece
/// localmente no proximo download completo, e ate la o dashboard abre vazio.
///
/// Monta a entidade pelo mesmo caminho do download (`fromFirestore`), para o
/// registro espelhado ser identico ao que a sincronizacao gravaria.
TecnicoEntity? espelhoDoTecnicoRecemCriado({
  required String firestoreId,
  required Map<String, dynamic> dados,
  required TecnicoEntity? jaNoCache,
}) {
  if (jaNoCache != null) return null;
  return TecnicoEntity.fromFirestore(dados, firestoreId);
}
