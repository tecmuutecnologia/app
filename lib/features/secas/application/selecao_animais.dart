/// Marcação de vários animais na aba "Descarte" de "Animais em secagem".
///
/// Com muitas vacas para eliminar, o técnico repetia botão e confirmação card
/// por card. No modo de seleção ele marca as que quer e confirma uma vez só.
///
/// Guarda chaves (texto) em vez dos animais: a lista da tela é recarregada do
/// ObjectBox após cada ação e os objetos mudam de identidade a cada carga.
class SelecaoAnimais {
  final Set<String> _chaves = {};
  bool _ativa = false;

  bool get ativa => _ativa;
  int get quantidade => _chaves.length;
  Iterable<String> get chaves => _chaves;

  bool contem(String chave) => _chaves.contains(chave);

  /// Liga o modo de seleção. [comChave] é o card pressionado e já entra
  /// marcado.
  void entrar({String? comChave}) {
    _ativa = true;
    if (comChave != null) _chaves.add(comChave);
  }

  void sair() {
    _ativa = false;
    _chaves.clear();
  }

  void alternar(String chave) {
    if (!_chaves.remove(chave)) _chaves.add(chave);
  }

  /// Marca todos os [visiveis] ou, se já estão todos marcados, desmarca.
  /// Mexe só nos visíveis: com a busca ativa, quem está escondido continua
  /// como estava.
  void alternarTodos(Iterable<String> visiveis) {
    if (todosMarcados(visiveis)) {
      _chaves.removeAll(visiveis);
    } else {
      _chaves.addAll(visiveis);
    }
  }

  bool todosMarcados(Iterable<String> visiveis) =>
      visiveis.isNotEmpty && visiveis.every(_chaves.contains);

  /// Esquece quem não está mais na aba (restaurado, eliminado ou trocado em
  /// outro aparelho), para a contagem do botão não prometer animal sumido.
  void manterApenas(Iterable<String> existentes) {
    final manter = existentes.toSet();
    _chaves.removeWhere((c) => !manter.contains(c));
  }
}

String rotuloAnimais(int n) => n == 1 ? '1 animal' : '$n animais';
