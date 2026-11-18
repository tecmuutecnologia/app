import 'package:intl/intl.dart';

/// Uma venda pronta para a aba Vendas do Financeiro.
class VendaResumo {
  const VendaResumo({
    required this.id,
    required this.titulo,
    required this.data,
    required this.dtTexto,
    required this.valor,
  });

  final String id;
  final String titulo;
  final DateTime? data;
  final String dtTexto;
  final double valor;
}

/// As vendas de um mês. `mes == null` é o grupo "Sem data".
class GrupoVendasMes {
  const GrupoVendasMes({
    required this.mes,
    required this.rotulo,
    required this.total,
    required this.vendas,
  });

  final DateTime? mes;
  final String rotulo;
  final double total;
  final List<VendaResumo> vendas;
}

/// Valor em reais no padrão brasileiro: `R$ 1.234,56`.
String formatarReais(double valor) =>
    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor);

/// `dd/MM/yyyy` estrito: rejeita dia/mês inexistente (31/02) em vez de
/// rolar para o mês seguinte como o `DateTime` faria.
DateTime? parseDataBr(String? texto) {
  final m =
      RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch((texto ?? '').trim());
  if (m == null) return null;
  final d = int.parse(m[1]!), mes = int.parse(m[2]!), a = int.parse(m[3]!);
  final data = DateTime(a, mes, d);
  if (data.year != a || data.month != mes || data.day != d) return null;
  return data;
}

/// Mês mais recente primeiro; dentro do mês, venda mais recente primeiro.
/// Vendas sem data válida vão para "Sem data", no fim — nunca derrubam a tela.
List<GrupoVendasMes> agruparVendasPorMes(List<VendaResumo> vendas) {
  final porMes = <DateTime?, List<VendaResumo>>{};
  for (final v in vendas) {
    final chave = v.data == null ? null : DateTime(v.data!.year, v.data!.month);
    porMes.putIfAbsent(chave, () => []).add(v);
  }
  final meses = porMes.keys.whereType<DateTime>().toList()
    ..sort((a, b) => b.compareTo(a));

  GrupoVendasMes grupo(DateTime? mes) {
    final lista = porMes[mes]!
      ..sort(
          (a, b) => (b.data ?? DateTime(0)).compareTo(a.data ?? DateTime(0)));
    return GrupoVendasMes(
      mes: mes,
      rotulo: mes == null ? 'Sem data' : _rotuloMes(mes),
      total: lista.fold(0.0, (s, v) => s + v.valor),
      vendas: lista,
    );
  }

  return [
    for (final m in meses) grupo(m),
    if (porMes.containsKey(null)) grupo(null),
  ];
}

/// `'pt'` (e não `'pt_BR'`): é o locale que o app carrega (`supportedLocales`)
/// e o `GlobalMaterialLocalizations` inicializa.
String _rotuloMes(DateTime mes) {
  final t = DateFormat('MMMM yyyy', 'pt').format(mes);
  return t[0].toUpperCase() + t.substring(1);
}
