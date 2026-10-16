/// Regras do bloco "Diagnóstico de Gestação" do receituário (tela e PDF).
library;

import 'package:intl/intl.dart';

const tiposDiagnostico = {'PP', 'DG+', 'DG-', 'Aborto'};

/// O que a consulta do dia precisa buscar: os diagnósticos mais a 'Secagem',
/// por causa do legado descrito em [tipoDiagnostico].
const tiposConsultaDiagnostico = {...tiposDiagnostico, 'Secagem'};

/// Tipo de diagnóstico que a ação representa, ou `null` se não for um.
///
/// Até out/2026 o formulário de DG+ gravava a ação como 'Secagem' para tudo
/// que não fosse do grupo "Vacas" — o DG+ das novilhas nunca aparecia no
/// receituário, só o PP. Esse registro se distingue da secagem de verdade
/// por ter `dtDgMais` (a tela de secagem não preenche esse campo).
String? tipoDiagnostico({required String? acao, String? dtDgMais}) {
  if (acao == 'Secagem') {
    return (dtDgMais != null && dtDgMais.isNotEmpty) ? 'DG+' : null;
  }
  return tiposDiagnostico.contains(acao) ? acao : null;
}

final _formato = DateFormat('dd/MM/yyyy');

/// A inseminação que o DG avaliou: a mais recente com data até [ate].
///
/// O DG- zera `dtUltimaInseminacao` do animal, então para as vazias a data
/// tem de vir do histórico de ações 'Inseminada' (`dataVisita` = dia da IA).
/// Devolve '' quando não há inseminação reconhecível.
String inseminacaoDiagnosticada(
  Iterable<String?> datasInseminacao, {
  required DateTime ate,
}) {
  final limite = DateTime(ate.year, ate.month, ate.day);
  DateTime? ultima;
  for (final texto in datasInseminacao) {
    if (texto == null || texto.isEmpty) continue;
    final DateTime data;
    try {
      data = _formato.parseStrict(texto);
    } on FormatException {
      continue;
    }
    if (data.isAfter(limite)) continue;
    if (ultima == null || data.isAfter(ultima)) ultima = data;
  }
  return ultima == null ? '' : _formato.format(ultima);
}
