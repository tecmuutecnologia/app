/// Regra ÚNICA de ordenação de animais em listas.
///
/// A regra sempre foi "brinco primeiro, depois nome", mas vivia duplicada em
/// quatro lugares com variações sutis, e seis telas não ordenavam nada — liam
/// direto do `getAll()` do ObjectBox, que devolve ordem de inserção. Como o
/// download grava na ordem de `documentId` do Firestore, a lista saía em
/// sequências como `[429, 428, 390, 430]`: nem numérica, nem alfabética.
library;

/// `true` quando o valor é um brinco de verdade.
///
/// `0` é o default de quem nunca recebeu brinco e `-1` é a sentinela herdada do
/// FlutterFlow. Tratar qualquer um deles como número faria o animal sem brinco
/// disputar as primeiras posições da lista.
bool temBrinco(int? brinco) =>
    brinco != null && brinco != 0 && brinco != -1;

/// Compara dois animais: quem tem brinco vem primeiro, em ordem numérica;
/// empate (ou ausência de brinco nos dois) desempata pelo nome.
///
/// O desempate por nome não é enfeite: sem ele, animais de mesmo brinco trocam
/// de posição a cada rebuild, porque `List.sort` não é estável em Dart.
int compararAnimais({
  required int? brincoA,
  required String? nomeA,
  required int? brincoB,
  required String? nomeB,
}) {
  final aTem = temBrinco(brincoA);
  final bTem = temBrinco(brincoB);

  if (aTem && bTem) {
    final c = brincoA!.compareTo(brincoB!);
    if (c != 0) return c;
    return _compararNomes(nomeA, nomeB);
  }

  if (aTem) return -1;
  if (bTem) return 1;

  return _compararNomes(nomeA, nomeB);
}

int _compararNomes(String? a, String? b) =>
    (a ?? '').toLowerCase().compareTo((b ?? '').toLowerCase());
