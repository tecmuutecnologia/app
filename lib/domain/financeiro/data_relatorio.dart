/// `dtRelatorio` é texto `dd/MM/yyyy`. Ordenar o TEXTO põe o dia na frente
/// do mês e do ano (30/01 vinha antes de 15/10), então toda ordenação por
/// data de relatório deve passar por aqui.
DateTime? dataDoRelatorio(String? texto) {
  final p = (texto ?? '').trim().split('/');
  if (p.length != 3) return null;
  final d = int.tryParse(p[0]), m = int.tryParse(p[1]), a = int.tryParse(p[2]);
  if (d == null || m == null || a == null) return null;
  return DateTime(a, m, d);
}

/// O relatório com a maior data real; texto inválido conta como o mais antigo.
T? relatorioMaisRecente<T>(Iterable<T> relatorios, String? Function(T) data) {
  T? melhor;
  DateTime? melhorData;
  for (final r in relatorios) {
    final dt = dataDoRelatorio(data(r)) ?? DateTime(0);
    if (melhor == null || dt.isAfter(melhorData!)) {
      melhor = r;
      melhorData = dt;
    }
  }
  return melhor;
}
