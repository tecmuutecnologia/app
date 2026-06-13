import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/objectbox/entities/index.dart';
import '../../../core/di/providers.dart';

/// Lista reativa de animais de uma propriedade, lida do ObjectBox via
/// `AnimalRepository` (offline-first), filtrando soft-deletes.
///
/// `family` pelo path do documento da propriedade (parentPath). A UI observa
/// este provider em vez de ler `FFAppState`/Firestore direto — qualquer escrita
/// local no repositório reflete automaticamente (ObjectBox `watch`).
final animaisByPropriedadeProvider =
    StreamProvider.family<List<AnimalEntity>, String>((ref, propriedadePath) {
  final repo = ref.watch(animalRepositoryProvider);
  return repo
      .watchAnimaisByPropriedade(propriedadePath)
      .map((animais) => animais.where((a) => !a.isDeleted).toList());
});

/// Argumentos do filtro por grupo (propriedade + nome do grupo, ex.: 'Vacas').
typedef AnimaisGrupoArgs = ({String propriedadePath, String grupo});

/// Lista reativa de animais de uma propriedade filtrada por grupo (aba).
/// Reusa o stream do repositório e filtra por `grupoAnimal` (e soft-deletes).
final animaisByGrupoProvider =
    StreamProvider.family<List<AnimalEntity>, AnimaisGrupoArgs>((ref, args) {
  final repo = ref.watch(animalRepositoryProvider);
  return repo.watchAnimaisByPropriedade(args.propriedadePath).map(
        (animais) => animais
            .where((a) => !a.isDeleted && a.grupoAnimal == args.grupo)
            .toList(),
      );
});
