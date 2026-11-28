/// Quais registros oferecer para um animal da roda e os textos de alerta.
/// As ações abrem as MESMAS janelas das telas de cada evento.
library;

import '/domain/animais/classificacao_animal.dart';
import '/domain/roda_reproducao/ciclo_reproducao.dart';
import '/domain/roda_reproducao/tarefas_semana.dart';

enum AcaoRoda { pp, dgMais, dgMenos, fezCio, inseminar, secagem, parto, exame }

const _dg = [AcaoRoda.pp, AcaoRoda.dgMais, AcaoRoda.dgMenos];
const _cobrir = [AcaoRoda.fezCio, AcaoRoda.inseminar];

/// Ações do card na [aba]; sem aba (lista da faixa, folha do animal ou
/// Atrasadas) decide pelo alerta e depois pelo estado.
List<AcaoRoda> acoesPara(PosicaoRoda p, {AbaSemana? aba, int diasDg = 30}) {
  switch (aba) {
    case AbaSemana.parir:
      return [AcaoRoda.parto];
    case AbaSemana.secar:
      return [AcaoRoda.secagem];
    case AbaSemana.diagnostico:
      return _dg;
    case AbaSemana.cio:
      return _cobrir;
    case AbaSemana.posParto:
      return [AcaoRoda.exame];
    case AbaSemana.atrasadas:
    case null:
      break;
  }

  final a = p.animal;
  // Inseminada nunca diagnosticada perto do parto: registrar o parto (ou
  // descartar a prenhez com DG−) vale mais que um PP agora.
  if (a.semDiagnostico &&
      (p.diasPosIa ?? 0) >= kGestacao - kJanelaSemana) {
    return [AcaoRoda.parto, AcaoRoda.dgMenos];
  }
  switch (p.alerta) {
    case AlertaRoda.semCobertura:
    case AlertaRoda.foraDoCiclo:
      return _cobrir;
    case AlertaRoda.dgAtrasado:
      return _dg;
    case AlertaRoda.secagemAtrasada:
      return [AcaoRoda.secagem];
    case AlertaRoda.partoAtrasado:
      return [AcaoRoda.parto];
    case null:
      break;
  }

  if (!a.coberta) return _cobrir;
  if (a.semDiagnostico) {
    return (p.diasPosIa ?? 0) >= diasDg ? _dg : [AcaoRoda.fezCio];
  }
  if (a.prenhe && a.vaca) return [AcaoRoda.secagem];
  return [AcaoRoda.parto];
}

/// Mesma regra do botão "DG +" da tela de DG: só depois do PP.
bool dgMaisHabilitado(PosicaoRoda p) =>
    ehInseminadaPP(p.animal.status) || p.animal.pp != null;

String _dias(int n) => n == 1 ? '1 dia' : '$n dias';

/// Frase curta do alerta, ou `null` quando o animal está na fase certa.
String? textoAlerta(PosicaoRoda p) => switch (p.alerta) {
      AlertaRoda.semCobertura =>
        'Sem cobertura há ${_dias(p.diasPosParto ?? p.diaBruto)} '
            '(ideal até $kDiaCobertura)',
      AlertaRoda.dgAtrasado => '${_dias(p.diasPosIa ?? 0)} da IA sem diagnóstico',
      AlertaRoda.secagemAtrasada =>
        'Secagem atrasada ${_dias(p.diaBruto - kDiaSecar)}',
      AlertaRoda.partoAtrasado =>
        'Parto atrasado ${_dias(p.diaBruto - kCiclo)}',
      AlertaRoda.foraDoCiclo =>
        'Fora do ciclo: ${_dias(p.diaBruto)} desde o parto',
      null => null,
    };
