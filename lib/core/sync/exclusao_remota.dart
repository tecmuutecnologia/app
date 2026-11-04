/// Exclusão que chega aos outros aparelhos.
///
/// O app apagava o documento de vez (`doc.delete()`). Os outros aparelhos só
/// buscam o que mudou desde a última sincronização (`lastModified` maior que a
/// marca), e um documento apagado não muda: some sem avisar ninguém. A
/// exclusão nunca chegava, e o item continuava aparecendo nos outros aparelhos.
///
/// Agora a exclusão é uma ESCRITA: o documento fica no Firestore com
/// [kCampoExcluido] e um `lastModified` novo. Escuta, pull e download completo
/// o recebem como qualquer alteração e removem o registro local.
///
/// O marcador é um campo próprio, e não `isDeleted`, porque a propriedade já
/// usa `isDeleted` para a lixeira, de onde ela ainda pode ser restaurada.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

const String kCampoExcluido = 'excluido';

/// `true` quando o documento remoto é uma exclusão definitiva.
bool ehExclusaoRemota(Map<String, dynamic>? data) =>
    data?[kCampoExcluido] == true;

/// O que gravar no lugar do `delete()`. `isDeleted` vai junto para que
/// leitores antigos, que já filtram por ele, também escondam o registro.
Map<String, dynamic> payloadDeExclusao() => {
      kCampoExcluido: true,
      'isDeleted': true,
      'excluidoEm': FieldValue.serverTimestamp(),
      'lastModified': FieldValue.serverTimestamp(),
    };

/// Marca o documento como excluído. Documento que já não existe (apagado por
/// uma versão anterior do app) conta como exclusão feita, e não fica
/// tentando de novo na fila para sempre.
Future<void> marcarExcluido(DocumentReference<Map<String, dynamic>> ref) async {
  try {
    await ref.update(payloadDeExclusao());
  } on FirebaseException catch (e) {
    if (e.code == 'not-found') return;
    rethrow;
  }
}

/// Separa os ids remotos excluídos dos que devem ser gravados.
({List<T> vivos, Set<String> excluidos}) separarExclusoes<T>(
  Iterable<T> docs, {
  required String Function(T) idDe,
  required Map<String, dynamic>? Function(T) dadosDe,
}) {
  final vivos = <T>[];
  final excluidos = <String>{};
  for (final d in docs) {
    if (ehExclusaoRemota(dadosDe(d))) {
      excluidos.add(idDe(d));
    } else {
      vivos.add(d);
    }
  }
  return (vivos: vivos, excluidos: excluidos);
}
