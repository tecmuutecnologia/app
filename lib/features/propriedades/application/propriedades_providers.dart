import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/objectbox/entities/index.dart';

/// Técnico logado, lido do ObjectBox (offline-first) e reativo.
///
/// Substitui o `StreamBuilder<List<TecnicoRecord>>` que envolvia a tela inteira
/// e a prendia num listener do Firestore (spinner infinito quando offline).
final tecnicoLogadoProvider = StreamProvider<TecnicoEntity?>((ref) {
  final uid = ref.watch(currentUserProvider).valueOrNull?.uid;
  if (uid == null) return Stream<TecnicoEntity?>.value(null);
  return ref.watch(tecnicoRepositoryProvider).watchByUidPerson(uid);
});

/// Path do documento do técnico logado (`tecnico/{id}`) — a chave das `family`
/// abaixo. Como é uma String estável entre rebuilds, o Riverpod reusa a mesma
/// stream em vez de recriá-la.
final tecnicoPathProvider = Provider<String?>((ref) {
  final id = ref.watch(tecnicoLogadoProvider).valueOrNull?.firestoreId;
  return id == null ? null : 'tecnico/$id';
});

/// Propriedades ativas do técnico (conta criada, não excluídas).
final propriedadesAtivasProvider =
    StreamProvider.family<List<PropriedadeEntity>, String>((ref, tecnicoPath) =>
        ref
            .watch(propriedadeRepositoryProvider)
            .watchAtivasByTecnico(tecnicoPath));

/// Lixeira do técnico (soft-deletes, restauráveis).
final propriedadesExcluidasProvider =
    StreamProvider.family<List<PropriedadeEntity>, String>((ref, tecnicoPath) =>
        ref
            .watch(propriedadeRepositoryProvider)
            .watchExcluidasByTecnico(tecnicoPath));

/// Propriedades criadas offline, aguardando ativação da conta do produtor.
final propriedadesPendentesProvider =
    StreamProvider.family<List<PropriedadeEntity>, String>((ref, tecnicoPath) =>
        ref
            .watch(propriedadeRepositoryProvider)
            .watchPendingActivation(tecnicoPath));

/// Uma propriedade pelo id do Firestore (tela de edição).
final propriedadeByIdProvider =
    StreamProvider.family<PropriedadeEntity?, String>((ref, firestoreId) => ref
        .watch(propriedadeRepositoryProvider)
        .watchByFirestoreId(firestoreId));

/// Uma propriedade pelo id LOCAL do ObjectBox (edição de propriedade pendente,
/// que ainda não tem firestoreId).
final propriedadeByLocalIdProvider =
    StreamProvider.family<PropriedadeEntity?, int>((ref, localId) =>
        ref.watch(propriedadeRepositoryProvider).watchByLocalId(localId));
