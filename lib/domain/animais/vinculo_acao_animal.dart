import '../../data/objectbox/entities/index.dart';

/// Caminho do animal no Firestore (`tecnico/{id}/animaisProdutores/{id}`), ou
/// `null` enquanto ele existir apenas no aparelho.
String? caminhoDoAnimal(AnimalEntity animal) {
  final parent = animal.parentPath;
  final id = animal.firestoreId;
  if (parent == null || parent.isEmpty || id == null || id.isEmpty) return null;
  return '$parent/animaisProdutores/$id';
}

/// `true` quando a ação pertence ao animal.
///
/// Animal já sincronizado é casado pelo CAMINHO; animal criado offline ainda
/// não tem `firestoreId`, e as ações dele guardam `uidAnimalOffline`. Casar só
/// pelo caminho deixava o animal offline sem histórico — e, no resumo de
/// rebanho, fora do relatório inteiro.
bool acaoEhDoAnimal(AcaoEntity acao, AnimalEntity animal) {
  final caminho = caminhoDoAnimal(animal);
  if (caminho != null &&
      (acao.uidAnimalAnimaisProdutoresPath ?? '').isNotEmpty) {
    return acao.uidAnimalAnimaisProdutoresPath == caminho;
  }

  final offline = animal.uidAnimalOffline ?? '';
  if (offline.isEmpty) return false;
  return acao.uidAnimalOffline == offline;
}
