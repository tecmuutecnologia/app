import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/sync/assinatura_local.dart';
import '../objectbox_service.dart';
import '../entities/index.dart';
import '../../../objectbox.g.dart';
import 'base_sync_repository.dart';

/// Repositório de Resumos de Visita (subcoleção `resumo_da_visita` de cada
/// propriedade). A sincronização é herdada de [BaseSyncRepository].
class ResumoVisitaRepository extends BaseSyncRepository<ResumoVisitaEntity> {
  ResumoVisitaRepository({
    ObjectBoxService? objectBox,
    super.syncService,
    super.firestore,
  }) : _objectBox = objectBox ?? ObjectBoxService.instance;

  final ObjectBoxService _objectBox;

  @override
  Box<ResumoVisitaEntity> get box => _objectBox.resumoVisitaBox;

  @override
  String get collectionName => 'resumo_da_visita';

  /// Reanexa os vínculos (guardados como caminho) e as datas como `Timestamp`.
  ///
  /// Sem isto, visita criada ONLINE subia com cinco campos e nenhuma
  /// referência: o download de visitas filtra por `uidPropriedade`, então o
  /// receituário não chegava ao produtor — e o próprio técnico o perderia no
  /// login seguinte. A reanexação existia só no laço de reenvio do
  /// `OfflineFirstSyncService`, que cobre o caso offline.
  @override
  Map<String, dynamic> firestorePayloadFor(ResumoVisitaEntity entity) {
    final data = entity.toFirestore();
    if (entity.uidPropriedadePath != null) {
      data['uidPropriedade'] = firestore.doc(entity.uidPropriedadePath!);
    }
    if (entity.uidTecnicoPath != null) {
      data['uidTecnico'] = firestore.doc(entity.uidTecnicoPath!);
    }
    if (entity.uidResumoDaVisitaPath != null) {
      data['uidResumoDaVisita'] = firestore.doc(entity.uidResumoDaVisitaPath!);
    }
    if (entity.dtVisita != null) {
      data['dtVisita'] = Timestamp.fromDate(entity.dtVisita!);
    }
    if (entity.dtAssinatura != null) {
      data['dtAssinatura'] = Timestamp.fromDate(entity.dtAssinatura!);
    }
    // Assinatura ainda no aparelho não sobe: `local:...` não é URL e quebraria
    // a imagem no outro aparelho e no app do produtor. Sem a chave, o merge
    // preserva o que o servidor tem; a URL sobe quando o arquivo chegar ao
    // Storage (AssinaturasLocais.enviarPendentes).
    if (ehAssinaturaLocal(entity.assinaturaTecnico)) {
      data.remove('assinaturaTecnico');
    }
    if (ehAssinaturaLocal(entity.assinaturaProdutor)) {
      data.remove('assinaturaProdutor');
    }
    return data;
  }

  /// Coleção top-level: todos os resumos compartilham o mesmo `parentPath`.
  /// O recorte por propriedade é feito pelo campo `uidPropriedadePath`.
  List<ResumoVisitaEntity> getByPropriedade(String propriedadePath) => box
      .query(ResumoVisitaEntity_.uidPropriedadePath.equals(propriedadePath))
      .build()
      .find();

  Stream<List<ResumoVisitaEntity>> watchByPropriedade(String propriedadePath) =>
      box
          .query(ResumoVisitaEntity_.uidPropriedadePath.equals(propriedadePath))
          .watch(triggerImmediately: true)
          .map((q) => q.find());

  /// O CREATE/UPDATE é feito por `_syncModifiedVisitas` (que reconcilia o
  /// `firestoreId`). Não enfileirar evita dupla-sync e o furo de reconcile.
  @override
  bool get syncedByModifiedLoop => true;

  /// Gera o `firestoreId` REAL já na criação local. Sem isso, um resumo criado
  /// offline só ganharia id no sync — e os tratamentos/recomendações filhos,
  /// que o referenciam por `uidResumoDaVisita`, ficariam órfãos.
  @override
  bool get preGeneratesFirestoreId => true;

  /// `resumo_da_visita` é TOP-LEVEL: o caminho da coleção não deriva de um
  /// documento pai (o `collectionPathFor` padrão concatenaria o parentPath).
  @override
  String collectionPathFor(ResumoVisitaEntity entity) => 'resumo_da_visita';

  ResumoVisitaEntity? getByFirestoreId(String firestoreId) => box
      .query(ResumoVisitaEntity_.firestoreId.equals(firestoreId))
      .build()
      .findFirst();

  @override
  List<ResumoVisitaEntity> getByParentPath(String parentPath) => box
      .query(ResumoVisitaEntity_.parentPath.equals(parentPath))
      .build()
      .find();

  @override
  List<ResumoVisitaEntity> getPendingSync() =>
      box.query(ResumoVisitaEntity_.needsSync.equals(true)).build().find();

  Stream<List<ResumoVisitaEntity>> watchByParentPath(String parentPath) => box
      .query(ResumoVisitaEntity_.parentPath.equals(parentPath))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
