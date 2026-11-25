/// "Esta semana" da Roda da Reprodução: o que fazer nos próximos 7 dias,
/// contadores por estado e o filtro por faixa. Regras puras.
library;

import '../animais/classificacao_animal.dart';
import 'ciclo_reproducao.dart';

/// Janela da semana, em dias a partir da data exibida.
const int kJanelaSemana = 7;

enum AbaSemana { parir, secar, diagnostico, cio, posParto, atrasadas }

String rotuloAba(AbaSemana aba) => switch (aba) {
      AbaSemana.parir => 'Parir',
      AbaSemana.secar => 'Secar',
      AbaSemana.diagnostico => 'Diagnóstico',
      AbaSemana.cio => 'Cio 21d',
      AbaSemana.posParto => 'Pós-parto 30d',
      AbaSemana.atrasadas => 'Atrasadas',
    };

/// Em quais abas da semana o animal aparece.
Set<AbaSemana> abasDe(PosicaoRoda p, {required int diasDg}) {
  final a = p.animal;
  final ia = p.diasPosIa;
  final pp = p.diasPosParto;
  return {
    // Inclui inseminada nunca diagnosticada perto do parto: o produtor vê a
    // vaca parindo e precisa registrar daqui.
    if (a.coberta && p.diaBruto >= kCiclo - kJanelaSemana) AbaSemana.parir,
    if (a.vaca &&
        ehPrenha(a.status) &&
        p.diaBruto >= kDiaSecar - kJanelaSemana)
      AbaSemana.secar,
    if (a.semDiagnostico && ia != null && ia >= diasDg) AbaSemana.diagnostico,
    if (a.semDiagnostico && ia != null && ia >= 18 && ia <= 24) AbaSemana.cio,
    if (!a.coberta && pp != null && pp >= 28 && pp <= 45) AbaSemana.posParto,
    if (p.alerta != null) AbaSemana.atrasadas,
  };
}

int _ordem(PosicaoRoda a, PosicaoRoda b) {
  final alerta = (b.alerta != null ? 1 : 0) - (a.alerta != null ? 1 : 0);
  if (alerta != 0) return alerta;
  return a.diaBruto.compareTo(b.diaBruto);
}

/// Todas as abas (inclusive vazias), cada uma com alertas primeiro e depois
/// por dia do ciclo.
Map<AbaSemana, List<PosicaoRoda>> agruparSemana(List<PosicaoRoda> ps,
    {required int diasDg}) {
  final grupos = {for (final aba in AbaSemana.values) aba: <PosicaoRoda>[]};
  for (final p in ps) {
    for (final aba in abasDe(p, diasDg: diasDg)) {
      grupos[aba]!.add(p);
    }
  }
  for (final lista in grupos.values) {
    lista.sort(_ordem);
  }
  return grupos;
}

/// Quantos animais de cada COR (estado real) estão na roda.
Map<FaseRoda, int> contarPorEstado(List<PosicaoRoda> ps) {
  final c = {for (final f in FaseRoda.values) f: 0};
  for (final p in ps) {
    if (p.naRoda) c[p.animal.faseEstado] = c[p.animal.faseEstado]! + 1;
  }
  return c;
}

/// Animais posicionados na faixa [f], alertas primeiro.
List<PosicaoRoda> naFaixa(List<PosicaoRoda> ps, FaseRoda f) =>
    ps.where((p) => p.naRoda && p.faixa == f).toList()..sort(_ordem);
