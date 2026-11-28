/// Regras puras da "Roda da Reprodução" (adaptação do app da Embrapa /
/// programa Balde Cheio).
///
/// A roda é um ciclo de 365 dias com "HOJE · PARTO" fixo embaixo. Cada animal
/// ocupa o dia do ciclo em que está; a **cor** é o estado real (status) e a
/// **faixa** é onde ele deveria estar. Quando os dois não batem, há alerta.
///
/// Regras completas em `docs/roda-da-reproducao.md`.
library;

import '../animais/classificacao_animal.dart';

const int kCiclo = 365;
const int kDiaCobertura = 83;
const int kFimCobertura = 143;
const int kDiaSecar = 305;

/// Gestação usada pelo app (`somarDataParto`): IA + 280.
const int kGestacao = 280;

/// Tolerâncias dos alertas.
const int kDiasSemDgAlerta = 60;
const int kTolerSecagem = 7;
const int kTolerParto = 3;

enum FaseRoda { posParto, cobertura, prenhe, seca }

FaseRoda faseDoDia(int dia) {
  if (dia < kDiaCobertura) return FaseRoda.posParto;
  if (dia < kFimCobertura) return FaseRoda.cobertura;
  if (dia < kDiaSecar) return FaseRoda.prenhe;
  return FaseRoda.seca;
}

const Map<FaseRoda, String> kNomeFase = {
  FaseRoda.posParto: 'Pós-parto',
  FaseRoda.cobertura: 'Cobertura',
  FaseRoda.prenhe: 'Prenhe',
  FaseRoda.seca: 'Seca',
};

enum AlertaRoda {
  semCobertura,
  dgAtrasado,
  secagemAtrasada,
  partoAtrasado,
  foraDoCiclo,
}

/// Dados mínimos de um animal para a roda (datas já convertidas, só dia).
class AnimalRoda {
  const AnimalRoda({
    required this.id,
    required this.nome,
    required this.brinco,
    required this.status,
    required this.grupo,
    this.parto,
    this.ia,
    this.partoPrevisto,
    this.dgMais,
    this.pp,
    this.inducao,
  });

  final String id;
  final String nome;
  final int brinco;
  final String status;
  final String grupo;
  final DateTime? parto;
  final DateTime? ia;
  final DateTime? partoPrevisto;
  final DateTime? dgMais;
  final DateTime? pp;
  final DateTime? inducao;

  /// Grupo "Novilhas" (canônico) ou "Novilha" (grafia legada).
  bool get novilha => ehNovilha(grupo) || grupo == 'Novilha';

  bool get vaca => ehVaca(grupo);

  bool get inseminada => ehInseminada(status) || ehInseminadaPP(status);

  /// Inseminada, prenhe, seca ou pré-parto: posição conta pela IA/parto
  /// previsto.
  bool get coberta =>
      inseminada || ehPrenha(status) || ehSeca(status) || ehPreParto(status);

  /// Inseminada com PP — status "Inseminada PP" ou PP registrado a partir
  /// da IA atual (PP de ciclo anterior não conta). Na roda conta como
  /// prenhe, pedido do usuário em 27/11/2026.
  bool get prenhePorPP =>
      inseminada &&
      (ehInseminadaPP(status) ||
          (pp != null && (ia == null || !pp!.isBefore(ia!))));

  /// Prenha de fato ou inseminada com PP.
  bool get prenhe => ehPrenha(status) || prenhePorPP;

  /// Inseminada sem PP nem DG+ deste ciclo (DG+ anterior à IA atual não
  /// conta).
  bool get semDiagnostico =>
      inseminada &&
      !prenhePorPP &&
      (dgMais == null || (ia != null && dgMais!.isBefore(ia!)));

  /// Fase pela COR: o estado real do animal.
  FaseRoda get faseEstado {
    if (ehSeca(status) || ehPreParto(status)) return FaseRoda.seca;
    if (prenhe) return FaseRoda.prenhe;
    if (inseminada) return FaseRoda.cobertura;
    return FaseRoda.posParto;
  }

  /// Parto previsto gravado ou, sem ele, IA + [kGestacao].
  DateTime? get partoPrevistoEfetivo =>
      partoPrevisto ?? ia?.add(const Duration(days: kGestacao));

  /// Início do pós-parto: o último parto ou, se mais recente, a indução de
  /// lactação. Aborto/DG−/cio não mudam a âncora.
  DateTime? get inicioLactacao {
    if (inducao != null && (parto == null || inducao!.isAfter(parto!))) {
      return inducao;
    }
    return parto;
  }
}

/// Situação de um animal numa data.
class PosicaoRoda {
  const PosicaoRoda({
    required this.animal,
    required this.diaBruto,
    required this.alerta,
    required this.diasPosIa,
    required this.diasPosParto,
  });

  final AnimalRoda animal;

  /// Dia do ciclo sem limite (pode passar de 365 ou ser negativo).
  final int diaBruto;
  final AlertaRoda? alerta;
  final int? diasPosIa;
  final int? diasPosParto;

  /// Dia desenhado na roda (0..364).
  int get dia => diaBruto.clamp(0, kCiclo - 1);

  /// Faixa onde o animal está (onde deveria estar pelo estado ideal).
  FaseRoda get faixa => faseDoDia(dia);

  /// Vazia há mais de um ciclo não tem lugar honesto na roda.
  bool get naRoda => alerta != AlertaRoda.foraDoCiclo;

  DateTime? get partoPrevistoEfetivo =>
      animal.coberta ? animal.partoPrevistoEfetivo : null;
}

int _dias(DateTime de, DateTime ate) => DateTime(ate.year, ate.month, ate.day)
    .difference(DateTime(de.year, de.month, de.day))
    .inDays;

bool _elegivel(AnimalRoda a) {
  if (ehDescarte(a.status)) return false;
  if (a.novilha) return a.coberta;
  return a.vaca;
}

/// Posição do animal na [data]; `null` quando ele não entra na roda
/// (bezerra, recria, descarte, novilha vazia ou sem nenhuma data útil).
PosicaoRoda? calcularPosicao(AnimalRoda a, DateTime data) {
  if (!_elegivel(a)) return null;

  final diasPosIa = a.ia == null ? null : _dias(a.ia!, data);
  final inicio = a.inicioLactacao;
  final diasPosParto = inicio == null ? null : _dias(inicio, data);

  final int diaBruto;
  if (a.coberta) {
    final previsto = a.partoPrevistoEfetivo;
    if (previsto == null) return null;
    diaBruto = kCiclo - _dias(data, previsto);
  } else {
    if (diasPosParto == null) return null;
    diaBruto = diasPosParto;
  }

  // Parto no futuro ou parto previsto a mais de um ciclo: dado impossível,
  // não tem lugar na roda (antes caía em "HOJE · PARTO" sem alerta).
  if (diaBruto < 0) return null;

  return PosicaoRoda(
    animal: a,
    diaBruto: diaBruto,
    alerta: _alerta(a, diaBruto, diasPosIa),
    diasPosIa: diasPosIa,
    diasPosParto: diasPosParto,
  );
}

AlertaRoda? _alerta(AnimalRoda a, int diaBruto, int? diasPosIa) {
  if (!a.coberta) {
    if (diaBruto > kCiclo) return AlertaRoda.foraDoCiclo;
    if (diaBruto > kDiaCobertura) return AlertaRoda.semCobertura;
    return null;
  }
  if (a.semDiagnostico) {
    return (diasPosIa ?? 0) > kDiasSemDgAlerta ? AlertaRoda.dgAtrasado : null;
  }
  if (diaBruto > kCiclo + kTolerParto) return AlertaRoda.partoAtrasado;
  if (a.prenhe &&
      a.vaca &&
      diaBruto > kDiaSecar + kTolerSecagem) {
    return AlertaRoda.secagemAtrasada;
  }
  return null;
}
