/// Carimbo da data da ultima acao no animal.
///
/// O selo "Hoje" nos cards (`listacompleta`, `exame_ginecologico`, `recria`)
/// acende comparando `dtUltimaAcao` com a data de hoje. Dos dez formularios
/// que registram uma acao, so o de "Acao" do exame ginecologico gravava esse
/// campo — por isso o selo parecia funcionar "quando lanco uma acao" e nao
/// quando lanco um PP, um DG, um cio ou uma inseminacao.
library;

import 'package:intl/intl.dart';

/// Formato que `verificaDataAcaoDataAtual` faz parse de volta. Qualquer outro
/// quebra a comparacao que acende o selo.
final _formato = DateFormat('dd/MM/yyyy');

String formatarDataDaAcao(DateTime quando) => _formato.format(quando);

/// Os dados que a tela ja ia gravar no animal, mais a data da acao.
///
/// Nao sobrescreve um `dtUltimaAcao` que a tela tenha informado: quem ja
/// carimbava continua mandando no valor.
Map<String, dynamic> comDataDaAcao(
  Map<String, dynamic> dados, {
  required DateTime quando,
}) =>
    {
      ...dados,
      if (!dados.containsKey('dtUltimaAcao'))
        'dtUltimaAcao': formatarDataDaAcao(quando),
    };

/// `true` quando a ultima acao do animal foi hoje — e o que acende o selo
/// "Hoje" nos cards.
///
/// Nao lanca. A versao anterior (`verificaDataAcaoDataAtual`) fazia
/// `DateFormat.parse` direto: as telas se protegiam so com `!= ''`, o que nao
/// cobre lixo gravado, e uma data invalida estourava no meio do build da
/// lista. Aqui data irreconhecivel apenas nao acende.
bool acaoFoiHoje(String? dtUltimaAcao, {DateTime? agora}) {
  if (dtUltimaAcao == null || dtUltimaAcao.isEmpty) return false;

  final DateTime data;
  try {
    data = _formato.parseStrict(dtUltimaAcao);
  } on FormatException {
    return false;
  }

  final hoje = agora ?? DateTime.now();
  return data.year == hoje.year &&
      data.month == hoje.month &&
      data.day == hoje.day;
}
