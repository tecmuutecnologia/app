import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tecmuu/domain/plano/plano_ativo.dart';

/// Localiza a `assinatura-ativa-tecnico` vigente do técnico.
///
/// Os limites de animais e produtores NÃO vêm do plano: vivem só no documento
/// `tecnico/{id}` (`limiteAnimaisContratado`, `limiteProdutoresContratado`) e
/// são mantidos pelos débitos/devoluções do app.
class AssinaturaAtivaService {
  AssinaturaAtivaService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// `whereIn` do Firestore aceita no máximo 30 valores por consulta.
  static const _loteWhereIn = 30;

  /// Documento de `assinatura-ativa-tecnico` vigente do técnico, ou `null`.
  Future<DocumentReference?> buscarAtiva(String tecnicoFirestoreId) async {
    final dados = await _carregar(tecnicoFirestoreId);
    if (dados == null) return null;
    // Reaproveita a mesma regra de desempate de [planoAtivoPath], trocando o
    // "plano" pelo próprio caminho da ativa.
    final caminho = planoAtivoPath(
      assinaturas: [
        for (final a in dados.ativas)
          AssinaturaResumo(path: a.id, planoPath: a.reference.path),
      ],
      ativas: [
        for (final a in dados.ativas)
          if (dados.assinaturaPaths.contains(_assinaturaDe(a)))
            AtivaResumo(assinaturaPath: a.id, dtAssinatura: _data(a)),
      ],
    );
    return caminho == null ? null : _firestore.doc(caminho);
  }

  /// Assinaturas do técnico e as ativas que apontam para elas.
  Future<_DadosAssinatura?> _carregar(String tecnicoFirestoreId) async {
    final assinaturasSnap = await _firestore
        .collection('assinatura-tecnico')
        .where('idTecnico',
            isEqualTo: _firestore.doc('tecnico/$tecnicoFirestoreId'))
        .get();
    if (assinaturasSnap.docs.isEmpty) return null;

    final refs = [for (final d in assinaturasSnap.docs) d.reference];
    final ativas = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    for (var i = 0; i < refs.length; i += _loteWhereIn) {
      final lote = refs.sublist(
          i, i + _loteWhereIn > refs.length ? refs.length : i + _loteWhereIn);
      final snap = await _firestore
          .collection('assinatura-ativa-tecnico')
          .where('idAssinaturaTecnico', whereIn: lote)
          .get();
      ativas.addAll(snap.docs);
    }

    return _DadosAssinatura(
      assinaturas: [
        for (final d in assinaturasSnap.docs)
          AssinaturaResumo(
            path: d.reference.path,
            planoPath: (d.data()['idPlano'] as DocumentReference?)?.path,
          ),
      ],
      ativas: ativas,
    );
  }

  static String? _assinaturaDe(DocumentSnapshot<Map<String, dynamic>> d) =>
      (d.data()?['idAssinaturaTecnico'] as DocumentReference?)?.path;

  static DateTime? _data(DocumentSnapshot<Map<String, dynamic>> d) {
    final v = d.data()?['dtAssinatura'];
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }
}

class _DadosAssinatura {
  _DadosAssinatura({required this.assinaturas, required this.ativas});

  final List<AssinaturaResumo> assinaturas;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> ativas;

  Set<String> get assinaturaPaths => {for (final a in assinaturas) a.path};
}
