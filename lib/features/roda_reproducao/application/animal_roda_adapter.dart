/// Converte o animal do banco local para o modelo puro da roda.
library;

import '/data/objectbox/entities/animal_entity.dart';
import '/domain/roda_reproducao/ciclo_reproducao.dart';

/// Datas fora deste intervalo são sentinelas/lixo (ex.: 31/12/2050).
DateTime? _valida(DateTime? d) {
  if (d == null || d.year < 1990 || d.year >= 2050) return null;
  return DateTime(d.year, d.month, d.day);
}

/// `d/M/aaaa` com ou sem zero à esquerda (dados legados/importados), estrito
/// quanto a dia inexistente (31/02 → null).
DateTime? _data(String? texto) {
  final m = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$')
      .firstMatch((texto ?? '').trim());
  if (m == null) return null;
  final d = int.parse(m[1]!), mes = int.parse(m[2]!), a = int.parse(m[3]!);
  final data = DateTime(a, mes, d);
  if (data.year != a || data.month != mes || data.day != d) return null;
  return _valida(data);
}

/// `id` = id local do ObjectBox (a página o usa para achar a entidade e
/// abrir as janelas de registro).
AnimalRoda animalRodaDe(AnimalEntity e) => AnimalRoda(
      id: '${e.id}',
      nome: e.nomeAnimal ?? '',
      brinco: e.brincoAnimal,
      status: e.status ?? '',
      grupo: e.grupoAnimal ?? '',
      parto: _data(e.dtUltimoParto),
      ia: _data(e.dtUltimaInseminacao),
      partoPrevisto: _data(e.dtPartoPrevisto),
      dgMais: _data(e.dtDgMais),
      pp: _data(e.dtPP),
      inducao: _valida(e.dtInducaoLactacao),
    );

/// Texto da bolinha: brinco de até 4 dígitos inteiro; 5+ dígitos mostra os 4
/// últimos (o número completo aparece na folha); sem brinco, a inicial do nome.
String rotuloBrinco(int brinco, String nome) {
  if (brinco > 0) {
    final s = '$brinco';
    return s.length <= 4 ? s : s.substring(s.length - 4);
  }
  final n = nome.trim();
  return n.isEmpty ? '?' : n[0].toUpperCase();
}
