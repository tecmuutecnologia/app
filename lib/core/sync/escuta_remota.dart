import '../../data/objectbox/entities/propriedade_entity.dart';
import 'alvos_animais_produtor.dart';

enum TipoEscuta { animais, acoes }

/// Uma coleção do Firestore a escutar em tempo real, opcionalmente restrita a
/// uma propriedade.
class AlvoEscuta {
  const AlvoEscuta({
    required this.tipo,
    required this.colecaoPath,
    this.campoPropriedade,
    this.propriedadePath,
  });

  final TipoEscuta tipo;

  /// `tecnico/{id}/animaisProdutores` ou `tecnico/{id}/acoes`.
  final String colecaoPath;

  /// Campo que aponta para a propriedade (`DocumentReference`). Nulo para o
  /// técnico, que escuta o rebanho inteiro.
  final String? campoPropriedade;

  /// `tecnico/{id}/propriedades/{id}` — o valor do filtro.
  final String? propriedadePath;

  /// `parentPath` das entidades gravadas a partir desta escuta: o técnico dono
  /// da coleção, igual ao download completo.
  String get parentPath =>
      colecaoPath.substring(0, colecaoPath.lastIndexOf('/'));

  @override
  bool operator ==(Object other) =>
      other is AlvoEscuta &&
      other.tipo == tipo &&
      other.colecaoPath == colecaoPath &&
      other.campoPropriedade == campoPropriedade &&
      other.propriedadePath == propriedadePath;

  @override
  int get hashCode =>
      Object.hash(tipo, colecaoPath, campoPropriedade, propriedadePath);

  @override
  String toString() => 'AlvoEscuta($tipo, $colecaoPath'
      '${propriedadePath == null ? '' : ', $campoPropriedade=$propriedadePath'})';
}

/// Onde o aparelho escuta mudanças feitas em OUTRO aparelho.
///
/// Técnico: as duas coleções dele, inteiras. Produtor: as mesmas coleções, mas
/// sob o técnico dono de cada propriedade e filtradas por ela — o produtor
/// enxerga o que é dele, não o rebanho que o técnico atende. Mesmo recorte do
/// download completo ([alvosAnimaisProdutor]).
///
/// [tecnicoPath] é o documento de técnico com o `uidPerson` do usuário, se
/// houver. Ele só vale se for dono de alguma propriedade local (ou se não
/// houver nenhuma — técnico recém-cadastrado): conta de produtor pode carregar
/// um técnico fantasma, e escutá-lo é escutar uma coleção vazia.
List<AlvoEscuta> alvosDeEscuta({
  required String? tecnicoPath,
  required List<PropriedadeEntity> propriedades,
}) {
  final ehTecnico = tecnicoPath != null &&
      (propriedades.isEmpty ||
          propriedades.any((p) => p.parentPath == tecnicoPath));

  if (ehTecnico) {
    return [
      AlvoEscuta(
        tipo: TipoEscuta.animais,
        colecaoPath: '$tecnicoPath/animaisProdutores',
      ),
      AlvoEscuta(tipo: TipoEscuta.acoes, colecaoPath: '$tecnicoPath/acoes'),
    ];
  }

  return [
    for (final alvo in alvosAnimaisProdutor(propriedades)) ...[
      AlvoEscuta(
        tipo: TipoEscuta.animais,
        colecaoPath: '${alvo.tecnicoPath}/animaisProdutores',
        campoPropriedade: 'uidTecnicoPropriedade',
        propriedadePath: alvo.propriedadePath,
      ),
      AlvoEscuta(
        tipo: TipoEscuta.acoes,
        colecaoPath: '${alvo.tecnicoPath}/acoes',
        campoPropriedade: 'uidPropriedade',
        propriedadePath: alvo.propriedadePath,
      ),
    ],
  ];
}
