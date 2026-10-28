/// Se a indução de lactação de um animal ainda vale.
///
/// A data de indução só era apagada pelo "Registrar parto induzido". Uma vaca
/// induzida que depois seguia o ciclo normal (inseminação, DG+, parto) ficava
/// com a marca para sempre e sumia do Exame ginecológico mesmo vazia — caso da
/// vaca 354 do Miorando. Aqui a indução vale até o primeiro desses eventos
/// DEPOIS dela, sem depender de alguém apagar o campo.
library;

/// `true` se há [dtInducao] e nenhum evento de ciclo (`dd/MM/yyyy`) num dia
/// posterior a ela. Evento no mesmo dia não encerra; datas vazias ou inválidas
/// são ignoradas.
bool inducaoLactacaoAtiva({
  required DateTime? dtInducao,
  String? dtUltimaInseminacao,
  String? dtDgMais,
  String? dtUltimoParto,
}) {
  if (dtInducao == null) return false;
  final diaInducao = DateTime(dtInducao.year, dtInducao.month, dtInducao.day);
  for (final texto in [dtUltimaInseminacao, dtDgMais, dtUltimoParto]) {
    final evento = _data(texto);
    if (evento != null && evento.isAfter(diaInducao)) return false;
  }
  return true;
}

DateTime? _data(String? texto) {
  final p = (texto ?? '').trim().split('/');
  if (p.length != 3) return null;
  final d = int.tryParse(p[0]), m = int.tryParse(p[1]), a = int.tryParse(p[2]);
  if (d == null || m == null || a == null) return null;
  return DateTime(a, m, d);
}
