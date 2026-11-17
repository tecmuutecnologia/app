/// Ordenação das listas de tratamento do receituário.
library;

import 'package:intl/intl.dart';

final _formato = DateFormat('dd/MM/yyyy');

DateTime? _data(String? texto) {
  if (texto == null || texto.isEmpty) return null;
  try {
    return _formato.parseStrict(texto);
  } catch (_) {
    return null;
  }
}

/// Compara duas datas `dd/MM/yyyy` deixando a mais velha primeiro e a mais
/// recente no fim, como no PDF do receituário. Quem não tem data válida vai
/// para depois de todas. Devolve 0 no empate — o desempate (brinco → nome)
/// fica com quem chama.
int compararDataMaisVelhaPrimeiro(String? a, String? b) {
  final da = _data(a);
  final db = _data(b);
  if (da == null && db == null) return 0;
  if (da == null) return 1;
  if (db == null) return -1;
  return da.compareTo(db);
}
