import '../../core/ui/custom_functions.dart' as functions;

/// Dias decorridos desde [data] (dd/MM/yyyy), ou `null` quando não há data ou
/// ela não está no formato esperado.
///
/// `calcularDiferencaEmDias` LANÇA `FormatException` nesses casos, e cada
/// chamador repetia um guard por fora. Onde o guard faltasse — ou onde a data
/// viesse torta do banco —, a exceção derrubava a tela ou a exportação inteira.
/// Aqui o guard mora uma vez só.
int? diasDesdeNum(String? data) {
  final texto = (data ?? '').trim();
  if (texto.isEmpty) return null;
  try {
    return functions.calcularDiferencaEmDias(texto);
  } on FormatException {
    return null;
  }
}

/// Texto do contador de dias desde um evento (DEL, "Dias IA").
///
/// Sem data (ou com data inválida) devolve [seVazio] — em branco nas listas,
/// `'N/D'` no prontuário.
String diasDesde(String? data, {String seVazio = ''}) =>
    diasDesdeNum(data)?.toString() ?? seVazio;
