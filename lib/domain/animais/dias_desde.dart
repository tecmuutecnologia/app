import '../../core/ui/custom_functions.dart' as functions;

/// Texto do contador de dias desde um evento (DEL, "Dias IA"), ou `''` quando
/// não há data.
///
/// `calcularDiferencaEmDias` LANÇA `FormatException` para data fora de
/// dd/MM/yyyy — inclusive vazia. Cada tela repetia um guard `!= ''` antes de
/// chamar, e onde o guard faltasse a tela quebrava. Aqui o guard mora uma vez
/// só, e data inválida vira campo vazio em vez de derrubar a lista.
String diasDesde(String? data) {
  final texto = (data ?? '').trim();
  if (texto.isEmpty) return '';
  try {
    return functions.calcularDiferencaEmDias(texto).toString();
  } on FormatException {
    return '';
  }
}
