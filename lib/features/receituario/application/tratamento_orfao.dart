/// Tratamentos do receituário que ficaram sem vínculo com a ação.
library;

import '../../../data/objectbox/entities/index.dart';

/// Se [t] é o tratamento da ação apagada, para os registros ANTIGOS que
/// nasceram sem `uidAcaoLancadaPath` (o formulário de ação nunca preenchia o
/// vínculo). Sem esta busca de reserva, apagar a ação no prontuário deixava a
/// linha no receituário — ex.: "Liberada" trocada por "IATF" aparecia nas duas.
///
/// Casa pelo mesmo animal, mesma ação e mesmo dia: o tratamento guarda a data
/// do lançamento (exame, secagem) ou a data digitada (calendário sanitário),
/// então aceita qualquer uma das duas.
bool ehTratamentoOrfaoDaAcao(
  TratamentoEntity t, {
  required String? animalPath,
  required String acao,
  required String dataVisita,
  required DateTime? dataLancamento,
}) {
  if (t.isDeleted) return false;
  if ((t.uidAcaoLancadaPath ?? '').isNotEmpty) return false;
  if (animalPath == null || animalPath.isEmpty) return false;
  if (t.uidAnimalPath != animalPath || t.tipoAcao != acao) return false;
  final dia = t.dtAcaoTratamento ?? '';
  return dia.isNotEmpty &&
      (dia == dataVisita ||
          (dataLancamento != null && dia == _ddMMyyyy(dataLancamento)));
}

String _ddMMyyyy(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
