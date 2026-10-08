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

/// Nome A-Z (ou Z-A). Animal sem nome vai para o fim nas DUAS direcoes: ele
/// nao e "o ultimo do alfabeto", esta fora da ordem, e inverter a lista nao
/// deve promove-lo ao topo.
int _porNome(AnimalEntity a, AnimalEntity b, bool crescente) {
  final nomeA = _normalizar(tituloAnimal(a));
  final nomeB = _normalizar(tituloAnimal(b));
  if (nomeA.isEmpty != nomeB.isEmpty) return nomeA.isEmpty ? 1 : -1;

  final comparacao = nomeA.compareTo(nomeB);
  if (comparacao != 0) return crescente ? comparacao : -comparacao;

  return _compararBrincos(a, b, crescente);
}

/// Brinco crescente (ou decrescente), com o mesmo tratamento para quem nao
/// tem brinco: fica no fim nas duas direcoes.
int _porBrinco(AnimalEntity a, AnimalEntity b, bool crescente) {
  final comparacao = _compararBrincos(a, b, crescente);
  if (comparacao != 0) return comparacao;

  final nomeA = _normalizar(tituloAnimal(a));
  final nomeB = _normalizar(tituloAnimal(b));
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
int _compararBrincos(AnimalEntity a, AnimalEntity b, bool crescente) {
  final aTem = temBrinco(a.brincoAnimal);
  final bTem = temBrinco(b.brincoAnimal);

  if (aTem != bTem) return aTem ? -1 : 1;
  if (!aTem) return 0;

  final comparacao = a.brincoAnimal.compareTo(b.brincoAnimal);
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
}) {
  final termo = _normalizar(busca);

  final filtrados = termo.isEmpty
      ? List<AnimalEntity>.of(animais)
      : animais
          .where((animal) =>
              _normalizar(tituloAnimal(animal)).contains(termo) ||
              _normalizar(animal.nomeAnimal).contains(termo) ||
              animal.brincoAnimal.toString().contains(termo))
          .toList();

  filtrados.sort((a, b) => ordem == OrdemAnimais.nome
      ? _porNome(a, b, crescente)
      : _porBrinco(a, b, crescente));
  return filtrados;
}
