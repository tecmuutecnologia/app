import '../../data/objectbox/entities/syncable_entity.dart';
import '../../data/objectbox/entities/visita_entities.dart';

/// `true` quando a entidade já existe no Firestore e não foi excluída — os
/// candidatos a reenvio para completar campos que faltaram na primeira escrita.
///
/// Quem ainda não subiu (`firestoreId` nulo) fica de fora: o push normal já o
/// cobre, agora com o payload completo.
bool jaSubiu(SyncableEntity e) =>
    !e.isDeleted && (e.firestoreId ?? '').isNotEmpty;

/// `true` quando a visita já subiu ao Firestore e tem, localmente, o vínculo
/// com a propriedade.
///
/// Esses são os documentos que podem estar no servidor sem `uidPropriedade`:
/// enquanto a reanexação das referências vivia só no laço de reenvio do
/// `OfflineFirstSyncService`, a criação ONLINE (pelo repositório) gravava apenas
/// os campos escalares. O documento existe, mas nenhum download o acha, porque
/// a busca de visitas filtra justamente por esse campo — o receituário não
/// chegava ao produtor e o técnico o perderia ao sair da conta.
///
/// Quem nunca subiu (`firestoreId` nulo) não entra: o push normal já o cobre,
/// agora com o payload completo.
bool precisaReenviarVinculo(ResumoVisitaEntity v) =>
    !v.isDeleted &&
    (v.firestoreId ?? '').isNotEmpty &&
    (v.uidPropriedadePath ?? '').isNotEmpty;
