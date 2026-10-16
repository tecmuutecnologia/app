import '../../../data/objectbox/entities/index.dart';
import '../../../domain/animais/ordenacao_animal.dart';

/// Como a lista de uma categoria e ordenada. Fica aqui, e nao no widget,
/// porque e regra pura: da para testar sem montar arvore de UI.
enum OrdemAnimais {
  nome,
  brinco,

  /// Data da última inseminação. Só a aba Novilhas da Recria oferece: é a
  /// ordem do manejo de quem está para emprenhar ou parir.
  inseminacao,
}

const _comAcento = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
const _semAcento = 'aaaaaeeeeiiiiooooouuuucn';

/// O texto que identifica o animal na lista — o MESMO que o card mostra.
///
/// Ordenar e buscar por `nomeAnimal` enquanto o card exibe `nomeBrincoConcat`
/// faz a lista parecer fora de ordem: o animal exibido como "001" tem
/// `nomeAnimal` "1" e cairia entre "004" e "22". Ordem e busca tem de operar
/// sobre o que o olho le.
String tituloAnimal(AnimalEntity animal) {
  final concat = animal.nomeBrincoConcat ?? '';
  return concat.isNotEmpty ? concat : (animal.nomeAnimal ?? '');
}

/// Minuscula, sem espaco nas pontas e sem acento.
///
/// O acento importa duas vezes: ordenar "Ângela" pelo codigo bruto a jogaria
/// depois de "Zulmira", e quem digita "angela" na busca nao encontraria o
/// animal gravado com "Â".
String _normalizar(String? texto) {
  if (texto == null) return '';
  final buffer = StringBuffer();
  for (final rune in texto.toLowerCase().trim().runes) {
    final char = String.fromCharCode(rune);
    final posicao = _comAcento.indexOf(char);
    buffer.write(posicao == -1 ? char : _semAcento[posicao]);
  }
  return buffer.toString();
}

/// Como ler um animal de qualquer tipo: a Recria lista `AnimalData` (do
/// struct) e as abas de Animais, `AnimalEntity`. A regra e a mesma.
typedef _Leitor<T> = ({
  String Function(T) titulo,
  String? Function(T) nome,
  int? Function(T) brinco,
  DateTime? Function(T)? dataInseminacao,
});

final _digito = RegExp(r'^[0-9]');
final _trecho = RegExp(r'[0-9]+|[^0-9]+');

/// Ordem "natural": trechos de digitos comparam pelo valor, nao como texto.
/// Sem isso "1000" vinha antes de "189", e "Novilha - 10" antes de
/// "Novilha - 2" — a lista parecia nao ter ordem nenhuma.
int _compararNatural(String a, String b) {
  final ta = _trecho.allMatches(a).map((m) => m[0]!).toList();
  final tb = _trecho.allMatches(b).map((m) => m[0]!).toList();
  for (var i = 0; i < ta.length && i < tb.length; i++) {
    final na = int.tryParse(ta[i]);
    final nb = int.tryParse(tb[i]);
    final c = (na != null && nb != null)
        ? na.compareTo(nb)
        : ta[i].compareTo(tb[i]);
    if (c != 0) return c;
  }
  final c = ta.length.compareTo(tb.length);
  return c != 0 ? c : a.compareTo(b);
}

/// Nome A-Z (ou Z-A). Titulo que comeca com numero (animal identificado so
/// pelo brinco) vem DEPOIS dos nomes nas duas direcoes, em ordem numerica.
/// Animal sem nome vai para o fim nas DUAS direcoes: ele nao e "o ultimo do
/// alfabeto", esta fora da ordem, e inverter a lista nao deve promove-lo ao
/// topo.
int _porNome<T>(T a, T b, bool crescente, _Leitor<T> ler) {
  final nomeA = _normalizar(ler.titulo(a));
  final nomeB = _normalizar(ler.titulo(b));
  if (nomeA.isEmpty != nomeB.isEmpty) return nomeA.isEmpty ? 1 : -1;

  final numeralA = _digito.hasMatch(nomeA);
  if (numeralA != _digito.hasMatch(nomeB)) return numeralA ? 1 : -1;

  final comparacao = _compararNatural(nomeA, nomeB);
  if (comparacao != 0) return crescente ? comparacao : -comparacao;

  return _compararBrincos(ler.brinco(a), ler.brinco(b), crescente);
}

/// Brinco crescente (ou decrescente), com o mesmo tratamento para quem nao
/// tem brinco: fica no fim nas duas direcoes.
int _porBrinco<T>(T a, T b, bool crescente, _Leitor<T> ler) {
  final comparacao = _compararBrincos(ler.brinco(a), ler.brinco(b), crescente);
  if (comparacao != 0) return comparacao;

  final nomeA = _normalizar(ler.titulo(a));
  final nomeB = _normalizar(ler.titulo(b));
  if (nomeA.isEmpty != nomeB.isEmpty) return nomeA.isEmpty ? 1 : -1;
  final porNome = _compararNatural(nomeA, nomeB);
  return crescente ? porNome : -porNome;
}

/// Mais antiga primeiro (ou mais recente). Sem data vai para o fim nas duas
/// direções; data igual desempata pela regra do brinco.
int _porInseminacao<T>(T a, T b, bool crescente, _Leitor<T> ler) {
  final dataA = ler.dataInseminacao?.call(a);
  final dataB = ler.dataInseminacao?.call(b);
  if ((dataA == null) != (dataB == null)) return dataA == null ? 1 : -1;
  if (dataA != null && dataB != null) {
    final comparacao = dataA.compareTo(dataB);
    if (comparacao != 0) return crescente ? comparacao : -comparacao;
  }
  return _porBrinco(a, b, crescente, ler);
}

/// Compara os brincos reusando `temBrinco` do dominio — a regra de que `0`
/// (nunca recebeu brinco) e `-1` (sentinela do FlutterFlow) NAO sao numeros de
/// brinco mora la, e comparar o inteiro cru faria o animal sem brinco
/// encabecar a lista.
///
/// A direcao fica aqui porque `compararAnimais` nao tem nocao de direcao: ele
/// responde uma ordem so. Devolve `0` quando os dois empatam ou nenhum tem
/// brinco — quem chama desempata pelo nome.
int _compararBrincos(int? a, int? b, bool crescente) {
  final aTem = temBrinco(a);
  final bTem = temBrinco(b);

  if (aTem != bTem) return aTem ? -1 : 1;
  if (!aTem) return 0;

  final comparacao = a!.compareTo(b!);
  return crescente ? comparacao : -comparacao;
}

/// Filtra pelo termo buscado e devolve a lista ordenada.
///
/// Busca casa por nome OU por brinco, no mesmo criterio ja usado na
/// `listacompleta`. Nao altera a lista recebida.
List<AnimalEntity> aplicarBuscaEOrdem(
  List<AnimalEntity> animais, {
  required OrdemAnimais ordem,
  bool crescente = true,
  String busca = '',
}) =>
    aplicarBuscaEOrdemPor<AnimalEntity>(
      animais,
      titulo: tituloAnimal,
      nome: (a) => a.nomeAnimal,
      brinco: (a) => a.brincoAnimal,
      ordem: ordem,
      crescente: crescente,
      busca: busca,
    );

/// [aplicarBuscaEOrdem] para qualquer tipo de animal, dado como ler o titulo
/// exibido no card, o nome e o brinco. [dataInseminacao] só é necessário para
/// [OrdemAnimais.inseminacao]; sem ele, todos contam como "sem data".
List<T> aplicarBuscaEOrdemPor<T>(
  List<T> animais, {
  required String Function(T) titulo,
  required String? Function(T) nome,
  required int? Function(T) brinco,
  DateTime? Function(T)? dataInseminacao,
  required OrdemAnimais ordem,
  bool crescente = true,
  String busca = '',
}) {
  final _Leitor<T> ler = (
    titulo: titulo,
    nome: nome,
    brinco: brinco,
    dataInseminacao: dataInseminacao,
  );
  final termo = _normalizar(busca);

  final filtrados = termo.isEmpty
      ? List<T>.of(animais)
      : animais
          .where((animal) =>
              _normalizar(titulo(animal)).contains(termo) ||
              _normalizar(nome(animal)).contains(termo) ||
              (brinco(animal)?.toString() ?? '').contains(termo))
          .toList();

  filtrados.sort((a, b) => switch (ordem) {
        OrdemAnimais.nome => _porNome(a, b, crescente, ler),
        OrdemAnimais.brinco => _porBrinco(a, b, crescente, ler),
        OrdemAnimais.inseminacao => _porInseminacao(a, b, crescente, ler),
      });
  return filtrados;
}
