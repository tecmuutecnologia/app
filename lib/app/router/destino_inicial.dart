import 'package:shared_preferences/shared_preferences.dart';

/// Onde o app abre quando ja existe sessao.
///
/// Guarda a *localizacao* de rota ja resolvida (ex.: `/dashboardTecnico`,
/// `/inicioPropriedadeProdutor?uidPropriedade=...`), gravada no fim da
/// sincronizacao — o unico momento em que o app sabe, com dado do servidor,
/// quem e o usuario e para onde ele vai.
///
/// Substitui a antiga `VerificaTipoLoginPage`, que redescobria isso a cada
/// abertura com duas consultas ao Firestore. Alem de custar duas idas a rede
/// no caminho critico, aquilo nao funcionava offline: sem cache, `person`
/// voltava nulo e um tecnico era mandado para a tela do produtor.
class DestinoInicial {
  const DestinoInicial._();

  static const _chave = 'ff_destinoInicial';

  /// Cache sincrono: a decisao acontece dentro do `redirect` da rota `/`, que
  /// nao pode esperar por I/O sem deixar a tela em branco.
  static SharedPreferences? _prefs;

  /// Chamado no bootstrap, antes do `runApp`.
  static Future<void> inicializar() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Nulo quando o app nunca concluiu uma sincronizacao nesta instalacao.
  static String? get valor => _prefs?.getString(_chave);

  static Future<void> guardar(String localizacao) async =>
      _prefs?.setString(_chave, localizacao);

  /// No logout: o proximo usuario deste aparelho nao pode herdar o destino.
  static Future<void> limpar() async => _prefs?.remove(_chave);
}
