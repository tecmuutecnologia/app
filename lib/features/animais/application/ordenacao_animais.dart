import '../../../data/objectbox/entities/index.dart';
import '../../../domain/animais/ordenacao_animal.dart';

/// Como a lista de uma categoria e ordenada. Fica aqui, e nao no widget,
/// porque e regra pura: da para testar sem montar arvore de UI.
enum OrdemAnimais { nome, brinco }

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
});

/// Nome A-Z (ou Z-A). Animal sem nome vai para o fim nas DUAS direcoes: ele
/// nao e "o ultimo do alfabeto", esta fora da ordem, e inverter a lista nao
/// deve promove-lo ao topo.
int _porNome<T>(T a, T b, bool crescente, _Leitor<T> ler) {
  final nomeA = _normalizar(ler.titulo(a));
  final nomeB = _normalizar(ler.titulo(b));
  if (nomeA.isEmpty != nomeB.isEmpty) return nomeA.isEmpty ? 1 : -1;

  final comparacao = nomeA.compareTo(nomeB);
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
  final porNome = nomeA.compareTo(nomeB);
  return crescente ? porNome : -porNome;
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
/// exibido no card, o nome e o brinco.
List<T> aplicarBuscaEOrdemPor<T>(
  List<T> animais, {
  required String Function(T) titulo,
  required String? Function(T) nome,
  required int? Function(T) brinco,
  required OrdemAnimais ordem,
  bool crescente = true,
  String busca = '',
}) {
  final _Leitor<T> ler = (titulo: titulo, nome: nome, brinco: brinco);
  final termo = _normalizar(busca);

  final filtrados = termo.isEmpty
      ? List<T>.of(animais)
      : animais
          .where((animal) =>
              _normalizar(titulo(animal)).contains(termo) ||
              _normalizar(nome(animal)).contains(termo) ||
              (brinco(animal)?.toString() ?? '').contains(termo))
          .toList();

  filtrados.sort((a, b) => ordem == OrdemAnimais.nome
      ? _porNome(a, b, crescente, ler)
      : _porBrinco(a, b, crescente, ler));
  return filtrados;
}
