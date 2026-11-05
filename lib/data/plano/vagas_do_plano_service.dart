import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:tecmuu/core/sync/decisao_recalculo.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/data/objectbox/objectbox_service.dart';
import 'package:tecmuu/data/objectbox/repositories/tecnico_repository.dart';
import 'package:tecmuu/domain/plano/plano_ativo.dart';
import 'package:tecmuu/domain/plano/vagas.dart';
import 'package:tecmuu/objectbox.g.dart' hide Query;

/// Limites do técnico vêm do plano ativo no Firestore; a ocupação vem da
/// contagem real no ObjectBox. Roda no aparelho do técnico, ao fim do sync.
class VagasDoPlanoService {
  VagasDoPlanoService(
      {FirebaseFirestore? firestore,
      ObjectBoxService? objectBox,
      bool Function()? baseIncompleta})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _objectBox = objectBox ?? ObjectBoxService.instance,
        _baseIncompletaInjetada = baseIncompleta;

  final FirebaseFirestore _firestore;
  final ObjectBoxService _objectBox;
  final bool Function()? _baseIncompletaInjetada;

  /// Mesma marca de `OfflineFirstSyncService.needsInitialSync`: sem o download
  /// inicial completo a contagem local sai menor e inflaria o saldo.
  bool _baseIncompleta() {
    final injetada = _baseIncompletaInjetada;
    if (injetada != null) return injetada();
    final q = _objectBox.syncMetadataBox
        .query(SyncMetadataEntity_.collectionName.equals('initial_download'))
        .build();
    try {
      final metadata = q.findFirst();
      return metadata == null || !metadata.initialSyncComplete;
    } finally {
      q.close();
    }
  }

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

  /// Recalcula limite, quantidade e restante de animais e produtores e grava
  /// só o que mudou. Nunca lança: o sync não pode cair por causa disto.
  Future<void> recalcular(String tecnicoFirestoreId) async {
    try {
      // Vale também para a tela do plano, que chama direto (fora do sync).
      if (_baseIncompleta()) return;
      final tecnicoPath = 'tecnico/$tecnicoFirestoreId';
      final repo =
          TecnicoRepository(objectBox: _objectBox, firestore: _firestore);
      final atual = repo.getByFirestoreId(tecnicoFirestoreId);
      if (atual == null) return;

      final limites = await _limitesDoPlano(tecnicoFirestoreId);

      final qAnimais = _objectBox.animalBox
          .query(AnimalEntity_.parentPath.equals(tecnicoPath))
          .build();
      final qProps = _objectBox.propriedadeBox
          .query(PropriedadeEntity_.parentPath.equals(tecnicoPath))
          .build();
      final List<AnimalEntity> animais;
      final List<PropriedadeEntity> props;
      try {
        animais = qAnimais.find();
        props = qProps.find();
      } finally {
        qAnimais.close();
        qProps.close();
      }

      final campos = camposParaGravar(
        atual: atual,
        animais: recalcularSaldo(
          limiteDoPlano: limites.animais,
          limiteAtual: atual.limiteAnimaisContratado,
          ativos: contarAnimaisAtivos(animais, tecnicoPath: tecnicoPath),
        ),
        produtores: recalcularSaldo(
          limiteDoPlano: limites.produtores,
          limiteAtual: atual.limiteProdutoresContratado,
          ativos: contarProdutoresAtivos(props, tecnicoPath: tecnicoPath),
        ),
        filaPendente: repo.temOperacaoPendente(tecnicoFirestoreId),
      );
      if (campos == null) return;

      // Servidor primeiro: se falhar, o local fica como estava e o próximo
      // sync tenta de novo.
      await _firestore.doc(tecnicoPath).update(campos);
      final local = aplicarAposGravar(
        fresca: repo.getByFirestoreId(tecnicoFirestoreId),
        campos: campos,
        filaPendente: repo.temOperacaoPendente(tecnicoFirestoreId),
      );
      if (local != null) _objectBox.tecnicoBox.put(local);
      debugPrint('📊 Vagas do plano recalculadas: $campos');
    } catch (e) {
      debugPrint('⚠️ Falha ao recalcular vagas do plano: $e');
    }
  }

  /// Falha ao ler o plano vira limite 0, que mantém o limite atual.
  Future<({int animais, int produtores})> _limitesDoPlano(
      String tecnicoFirestoreId) async {
    try {
      final dados = await _carregar(tecnicoFirestoreId);
      if (dados == null) return (animais: 0, produtores: 0);
      final planoPath = planoAtivoPath(
        assinaturas: dados.assinaturas,
        ativas: [
          for (final a in dados.ativas)
            AtivaResumo(
                assinaturaPath: _assinaturaDe(a), dtAssinatura: _data(a)),
        ],
      );
      if (planoPath == null) return (animais: 0, produtores: 0);
      final plano = (await _firestore.doc(planoPath).get()).data();
      return (
        animais: (plano?['limiteAnimais'] as num?)?.toInt() ?? 0,
        produtores: (plano?['limitePropriedade'] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      debugPrint('⚠️ Falha ao ler o plano ativo: $e');
      return (animais: 0, produtores: 0);
    }
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
