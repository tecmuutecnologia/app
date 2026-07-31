import '../../data/objectbox/entities/propriedade_entity.dart';

/// Onde procurar os animais (e as ações) de UMA propriedade do produtor.
///
/// Os animais não ficam sob a propriedade: vivem em
/// `tecnico/{id}/animaisProdutores`, cada um apontando para a sua propriedade
/// no campo `uidTecnicoPropriedade`. Para buscar os de um produtor é preciso,
/// então, das duas pontas — o técnico onde consultar e a propriedade pela qual
/// filtrar.
class AlvoAnimaisProdutor {
  const AlvoAnimaisProdutor({
    required this.tecnicoPath,
    required this.propriedadePath,
  });

  /// `tecnico/{id}` — onde está a subcoleção.
  final String tecnicoPath;

  /// `tecnico/{id}/propriedades/{id}` — o valor de `uidTecnicoPropriedade`.
  final String propriedadePath;

  @override
  bool operator ==(Object other) =>
      other is AlvoAnimaisProdutor &&
      other.tecnicoPath == tecnicoPath &&
      other.propriedadePath == propriedadePath;

  @override
  int get hashCode => Object.hash(tecnicoPath, propriedadePath);
}

/// Deriva os alvos de download a partir das propriedades que o produtor já tem
/// localmente (o download de propriedades roda antes e as grava com o
/// `parentPath` do técnico dono).
///
/// Existe porque o download completo só sabia baixar animais quando havia um
/// documento de técnico. Quem entra como produtor não tem um, então o download
/// desistia e o aparelho ficava só com o que fora criado offline ali.
///
/// Filtrar por propriedade não é detalhe de performance: o produtor enxerga o
/// que é dele, não o rebanho inteiro que aquele técnico atende.
List<AlvoAnimaisProdutor> alvosAnimaisProdutor(
  List<PropriedadeEntity> propriedades,
) {
  final alvos = <AlvoAnimaisProdutor>[];

  for (final propriedade in propriedades) {
    final firestoreId = propriedade.firestoreId;
    final parentPath = propriedade.parentPath;

    // Propriedade criada offline que ainda não subiu não tem documento para
    // filtrar — seus animais também ainda são só locais.
    if (firestoreId == null || firestoreId.isEmpty) continue;
    if (parentPath == null || parentPath.isEmpty) continue;

    final alvo = AlvoAnimaisProdutor(
      tecnicoPath: parentPath,
      propriedadePath: '$parentPath/propriedades/$firestoreId',
    );
    if (!alvos.contains(alvo)) alvos.add(alvo);
  }

  return alvos;
}
