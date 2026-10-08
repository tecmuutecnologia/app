import '../../data/objectbox/entities/propriedade_entity.dart';
import '../../data/objectbox/entities/visita_entities.dart';
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
    this.apenasPull = false,
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

  /// `true` quando este alvo entra SO no pull incremental, sem abrir escuta em
  /// tempo real.
  ///
  /// Existe por causa dos tratamentos e recomendacoes no aparelho do tecnico:
  /// sao subcolecao de CADA propriedade, e uma conta com 30 delas abriria 60
  /// conexoes permanentes. O pull cobre o mesmo dado lendo so o que mudou
  /// desde a ultima sincronizacao, ao custo de alguns minutos de atraso.
  final bool apenasPull;

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
      other.valorRefPath == valorRefPath &&
      other.apenasPull == apenasPull;

  @override
  int get hashCode =>
      Object.hash(tipo, colecaoPath, campoFiltro, valorRefPath, apenasPull);

  @override
  String toString() => 'AlvoEscuta($tipo, $colecaoPath'
      '${valorRefPath == null ? '' : ', $campoFiltro=$valorRefPath'}'
      '${apenasPull ? ', apenasPull' : ''})';
}



/// Sob qual marca de sincronizacao este alvo guarda o seu "ate quando ja li".
///
/// Alvos de escuta compartilham a marca da ETAPA. Um alvo de pull precisa da
/// sua propria: a marca de `financeiro` ja avancou por causa das visitas, e um
/// alvo novo que a herdasse comecaria a janela depois dos tratamentos que ja
/// existem — eles nunca desceriam. Com marca propria, o primeiro pull de cada
/// subcolecao parte da epoca e traz tudo (e pouca coisa: os tratamentos de UMA
/// propriedade).
String chaveDeMarca(AlvoEscuta alvo, String chaveDaEtapa) =>
    alvo.apenasPull ? 'pull_${alvo.colecaoPath}' : chaveDaEtapa;

/// Propriedades com visita recente o bastante para valer a pena buscar os
/// tratamentos e recomendacoes dela.
///
/// Sem este recorte o tecnico consultaria as duas subcolecoes de TODAS as
/// propriedades a cada ciclo de sincronizacao — 60 consultas numa conta com 30
/// propriedades, quase todas devolvendo nada. O receituario so muda enquanto a
/// visita esta acontecendo.
Set<String> propriedadesComVisitaRecente(
  List<ResumoVisitaEntity> visitas, {
  required DateTime agora,
  Duration janela = const Duration(days: 7),
}) {
  final limite = agora.subtract(janela);
  return {
    for (final v in visitas)
      if (!v.isDeleted &&
          v.uidPropriedadePath != null &&
          v.dtVisita != null &&
          v.dtVisita!.isAfter(limite))
        v.uidPropriedadePath!,
  };
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
  Set<String> propriedadesComVisita = const {},
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
      // Tratamentos e recomendacoes: a acao lancada pelo PRODUTOR vira um
      // deles, e sem estes alvos o receituario do tecnico mostrava as acoes
      // (PP, DG+) e escondia o resto (CG II, pre-parto). Entram so no pull e
      // so para as propriedades com visita recente — ver [apenasPull].
      for (final propriedadePath in propriedadesComVisita) ...[
        AlvoEscuta(
          tipo: TipoEscuta.tratamentos,
          colecaoPath: '$propriedadePath/tratamentos',
          apenasPull: true,
        ),
        AlvoEscuta(
          tipo: TipoEscuta.recomendacoes,
          colecaoPath: '$propriedadePath/recomendacoes',
          apenasPull: true,
        ),
      ],
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
