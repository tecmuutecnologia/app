import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/objectbox/entities/index.dart';
import '../../../core/di/providers.dart';
import '../../../domain/animais/classificacao_animal.dart';

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

/// Quantidade de animais ativos do técnico, lida do ObjectBox.
///
/// Antes vinha de um `.snapshots()` do Firestore com `limit: 500` — um stream
/// ao vivo de até 500 documentos para exibir um número que já estava local.
///
/// Sem `family`: o cache local contém apenas os animais do técnico logado,
/// então "todos" já é o rebanho dele.
/// Lista reativa de TODOS os animais do aparelho, filtrando soft-deletes.
///
/// Sem `family` pelo mesmo motivo do `watchTodos` do repositorio: o cache local
/// contem apenas os animais do tecnico logado, entao "todos" ja e o rebanho
/// dele. Telas que liam com `getAll()` no `initState` — uma fotografia que nao
/// reagia a escrita nenhuma — passam a observar isto.
final animaisTodosProvider = StreamProvider<List<AnimalEntity>>((ref) {
  final repo = ref.watch(animalRepositoryProvider);
  return repo
      .watchTodos()
      .map((animais) => animais.where((a) => !a.isDeleted).toList());
});

final animaisAtivosCountProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(animalRepositoryProvider);
  return repo.watchTodos().map(
        (animais) => animais
            .where((a) =>
                !a.isDeleted &&
                !ehDescarte(a.status) &&
                a.grupoAnimal != 'Sêmens')
            .length,
      );
});
