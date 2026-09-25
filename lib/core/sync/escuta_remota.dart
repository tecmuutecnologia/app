import '../../data/objectbox/entities/propriedade_entity.dart';
import 'alvos_animais_produtor.dart';

enum TipoEscuta { animais, acoes, visitas, tratamentos, recomendacoes }

/// Uma coleção do Firestore a escutar em tempo real, opcionalmente restrita a
/// uma propriedade.
class AlvoEscuta {
  const AlvoEscuta({
    required this.tipo,
    required this.colecaoPath,
    this.campoFiltro,
    this.valorRefPath,
  });

  final TipoEscuta tipo;

  /// Caminho da coleção: sob o técnico (`animaisProdutores`, `acoes`), sob a
  /// propriedade (`tratamentos`, `recomendacoes`) ou top-level
  /// (`resumo_da_visita`).
  final String colecaoPath;

  /// Campo de referência pelo qual filtrar (`uidTecnicoPropriedade`,
  /// `uidPropriedade`, `uidTecnico`). Nulo quando a própria coleção já é o
  /// recorte — caso das subcoleções da propriedade e do técnico que escuta o
  /// rebanho inteiro.
  final String? campoFiltro;

  /// Documento que o [campoFiltro] tem de apontar.
  final String? valorRefPath;

  /// `parentPath` das entidades gravadas a partir desta escuta, igual ao que o
  /// download completo usa: o documento pai da coleção, ou a própria coleção
  /// quando ela é top-level (`resumo_da_visita`).
  String get parentPath => colecaoPath.contains('/')
      ? colecaoPath.substring(0, colecaoPath.lastIndexOf('/'))
      : colecaoPath;

  @override
  bool operator ==(Object other) =>
      other is AlvoEscuta &&
      other.tipo == tipo &&
      other.colecaoPath == colecaoPath &&
      other.campoFiltro == campoFiltro &&
      other.valorRefPath == valorRefPath;

  @override
  int get hashCode => Object.hash(tipo, colecaoPath, campoFiltro, valorRefPath);

  @override
  String toString() => 'AlvoEscuta($tipo, $colecaoPath'
      '${valorRefPath == null ? '' : ', $campoFiltro=$valorRefPath'})';
}

/// `true` quando o aparelho é de um TÉCNICO.
///
/// [tecnicoPath] é o documento de técnico com o `uidPerson` do usuário, se
/// houver. Ele só vale se for dono de alguma propriedade local (ou se não houver
/// nenhuma — técnico recém-cadastrado): conta de produtor pode carregar um
/// técnico fantasma, sobra de cadastro indevido, e tomá-lo por técnico faz o
/// app escutar e reparar a coleção errada.
bool ehAparelhoDeTecnico({
  required String? tecnicoPath,
  required List<PropriedadeEntity> propriedades,
}) =>
    tecnicoPath != null &&
    (propriedades.isEmpty ||
        propriedades.any((p) => p.parentPath == tecnicoPath));

/// Onde o aparelho escuta mudanças feitas em OUTRO aparelho.
///
/// Técnico: as duas coleções dele, inteiras. Produtor: as mesmas coleções, mas
/// sob o técnico dono de cada propriedade e filtradas por ela — o produtor
/// enxerga o que é dele, não o rebanho que o técnico atende. Mesmo recorte do
/// download completo ([alvosAnimaisProdutor]). Quem decide o papel é
/// [ehAparelhoDeTecnico].
List<AlvoEscuta> alvosDeEscuta({
  required String? tecnicoPath,
  required List<PropriedadeEntity> propriedades,
}) {
  if (ehAparelhoDeTecnico(
      tecnicoPath: tecnicoPath, propriedades: propriedades)) {
    return [
      AlvoEscuta(
        tipo: TipoEscuta.animais,
        colecaoPath: '$tecnicoPath/animaisProdutores',
      ),
      AlvoEscuta(tipo: TipoEscuta.acoes, colecaoPath: '$tecnicoPath/acoes'),
      // Só a visita: tratamentos e recomendações são subcoleção de CADA
      // propriedade, e escutá-las numa conta com dezenas delas abriria dezenas
      // de conexões. O técnico emite o receituário — ele já tem tudo local; a
      // visita cobre um segundo aparelho dele.
      AlvoEscuta(
        tipo: TipoEscuta.visitas,
        colecaoPath: 'resumo_da_visita',
        campoFiltro: 'uidTecnico',
        valorRefPath: tecnicoPath,
      ),
    ];
  }

  return [
    for (final alvo in alvosAnimaisProdutor(propriedades)) ...[
      AlvoEscuta(
        tipo: TipoEscuta.animais,
        colecaoPath: '${alvo.tecnicoPath}/animaisProdutores',
        campoFiltro: 'uidTecnicoPropriedade',
        valorRefPath: alvo.propriedadePath,
      ),
      AlvoEscuta(
        tipo: TipoEscuta.acoes,
        colecaoPath: '${alvo.tecnicoPath}/acoes',
        campoFiltro: 'uidPropriedade',
        valorRefPath: alvo.propriedadePath,
      ),
      // Receituário: a visita é top-level e se liga à propriedade por campo; os
      // tratamentos e as recomendações são subcoleções dela.
      AlvoEscuta(
        tipo: TipoEscuta.visitas,
        colecaoPath: 'resumo_da_visita',
        campoFiltro: 'uidPropriedade',
        valorRefPath: alvo.propriedadePath,
      ),
      AlvoEscuta(
        tipo: TipoEscuta.tratamentos,
        colecaoPath: '${alvo.propriedadePath}/tratamentos',
      ),
      AlvoEscuta(
        tipo: TipoEscuta.recomendacoes,
        colecaoPath: '${alvo.propriedadePath}/recomendacoes',
      ),
    ],
  ];
}
