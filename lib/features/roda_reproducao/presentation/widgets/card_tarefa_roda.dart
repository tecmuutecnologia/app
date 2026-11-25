/// Card de um animal na lista "Esta semana" / faixa, e a folha inferior que
/// abre ao tocar numa bolinha da roda.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/theme/flutter_flow_theme.dart';
import '/core/ui/app_card.dart';
import '/core/ui/card_animal_lista.dart';
import '/core/ui/flutter_flow_widgets.dart';
import '/domain/roda_reproducao/ciclo_reproducao.dart';
import '/domain/roda_reproducao/tarefas_semana.dart';
import '../../application/acoes_roda.dart';
import 'roda_widget.dart';

String fmtData(DateTime? d) => d == null
    ? ''
    : '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

/// Cor do selo de status: a do animal, escurecida quando é clara demais para
/// texto (amarelo, rosa-claro).
Color corSeloAnimal(AnimalRoda a) {
  final c = corDoAnimal(a);
  return c.computeLuminance() > 0.45 ? Color.lerp(c, Colors.black, 0.42)! : c;
}

String textoStatus(AnimalRoda a) =>
    a.novilha ? 'Novilha · ${a.status}' : a.status;

/// Informações do card conforme a aba (ou, sem aba, conforme o estado).
List<InfoAnimal> infoDoCard(PosicaoRoda p, AbaSemana? aba) {
  final a = p.animal;
  final previsto = p.partoPrevistoEfetivo;
  InfoAnimal dias(String rotulo, int? n) =>
      InfoAnimal(rotulo, n == null ? '' : '$n', ehData: false);
  switch (aba) {
    case AbaSemana.parir:
      final falta = previsto == null ? null : kCiclo - p.diaBruto;
      return [
        InfoAnimal('Parto previsto', fmtData(previsto)),
        falta != null && falta < 0
            ? dias('Dias de atraso', -falta)
            : dias('Faltam (dias)', falta),
      ];
    case AbaSemana.secar:
      return [
        InfoAnimal('Secar até',
            fmtData(previsto?.subtract(const Duration(days: kCiclo - kDiaSecar)))),
        InfoAnimal('Parto previsto', fmtData(previsto)),
      ];
    case AbaSemana.diagnostico:
    case AbaSemana.cio:
      return [
        InfoAnimal('Inseminada em', fmtData(a.ia)),
        dias('Dias IA', p.diasPosIa),
      ];
    case AbaSemana.posParto:
      return [
        InfoAnimal('Pariu em', fmtData(a.inicioLactacao)),
        dias('Dias pós-parto', p.diasPosParto),
      ];
    case AbaSemana.atrasadas:
    case null:
      if (!a.coberta) {
        return [
          InfoAnimal('Último parto', fmtData(a.inicioLactacao)),
          dias('Dias pós-parto', p.diasPosParto),
        ];
      }
      if (a.semDiagnostico) {
        return [
          InfoAnimal('Inseminada em', fmtData(a.ia)),
          dias('Dias IA', p.diasPosIa),
        ];
      }
      return [
        InfoAnimal('Parto previsto', fmtData(previsto)),
        dias('Dia do ciclo', p.diaBruto),
      ];
  }
}

/// Rótulo, ícone e cor de cada ação (cores do padrão de listas).
(String, IconData, Color) visualAcao(BuildContext context, AcaoRoda acao) =>
    switch (acao) {
      AcaoRoda.pp => ('PP', Icons.notifications, const Color(0xFF0F9488)),
      AcaoRoda.dgMais => ('DG +', Icons.check_circle, AppTokens.positivo),
      AcaoRoda.dgMenos =>
        ('DG -', Icons.cancel_rounded, FlutterFlowTheme.of(context).error),
      AcaoRoda.fezCio => ('Fez cio', Icons.repeat, AppTokens.positivo),
      AcaoRoda.inseminar => ('Inseminar', Icons.add_circle, AppTokens.brand),
      AcaoRoda.secagem => ('Secagem', Icons.water_drop, AppTokens.positivo),
      AcaoRoda.parto => ('Parto', Icons.add_alert, AppTokens.positivo),
      AcaoRoda.exame => ('Exame', Icons.add_alert, AppTokens.positivo),
    };

class BotoesAcaoRoda extends StatelessWidget {
  const BotoesAcaoRoda({
    super.key,
    required this.posicao,
    required this.acoes,
    required this.aoAgir,
  });

  final PosicaoRoda posicao;
  final List<AcaoRoda> acoes;
  final void Function(AcaoRoda) aoAgir;

  @override
  Widget build(BuildContext context) {
    return LinhaAcoes(children: [
      for (final acao in acoes)
        Builder(builder: (context) {
          final (texto, icone, cor) = visualAcao(context, acao);
          final habilitado =
              acao != AcaoRoda.dgMais || dgMaisHabilitado(posicao);
          return FFButtonWidget(
            onPressed: habilitado ? () => aoAgir(acao) : null,
            text: texto,
            icon: Icon(icone, size: 15.0),
            options: opcoesBotaoCard(context, cor),
          );
        }),
    ]);
  }
}

/// Faixa vermelha com o motivo do alerta.
class AvisoAlertaRoda extends StatelessWidget {
  const AvisoAlertaRoda(this.texto, {super.key});
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTokens.negativo.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
      ),
      child: Row(children: [
        const Icon(Icons.error_rounded, size: 16, color: AppTokens.negativo),
        const SizedBox(width: 6),
        Expanded(
          child: Text(texto,
              style: GoogleFonts.readexPro(
                  color: AppTokens.negativo,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}

class CardTarefaRoda extends StatelessWidget {
  const CardTarefaRoda({
    super.key,
    required this.posicao,
    required this.aba,
    required this.diasDg,
    required this.aoAgir,
    required this.aoTocar,
  });

  final PosicaoRoda posicao;
  final AbaSemana? aba;
  final int diasDg;
  final void Function(AcaoRoda) aoAgir;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final a = posicao.animal;
    final alerta = textoAlerta(posicao);
    return CartaoLista(
      aoTocar: aoTocar,
      child: ConteudoCardAnimal(
        grupo: a.grupo,
        titulo: tituloNomeBrinco(a.nome, a.brinco),
        selo: SeloStatus(textoStatus(a), cor: corSeloAnimal(a)),
        info: infoDoCard(posicao, aba),
        acoes: Column(mainAxisSize: MainAxisSize.min, children: [
          if (alerta != null) ...[
            AvisoAlertaRoda(alerta),
            const SizedBox(height: 10),
          ],
          BotoesAcaoRoda(
            posicao: posicao,
            acoes: acoesPara(posicao, aba: aba, diasDg: diasDg),
            aoAgir: aoAgir,
          ),
        ]),
      ),
    );
  }
}

/// Folha inferior do animal tocado na roda. Devolve a ação escolhida (ou
/// `'prontuario'`) ao fechar; quem abriu executa.
class FolhaAnimalRoda extends StatelessWidget {
  const FolhaAnimalRoda({
    super.key,
    required this.posicao,
    required this.diasDg,
  });

  final PosicaoRoda posicao;
  final int diasDg;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final a = posicao.animal;
    final alerta = textoAlerta(posicao);
    final cor = corDoAnimal(a);
    Widget dado(String rotulo, String valor) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: tema.primaryBackground,
              borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
            ),
            child: InfoAnimal(rotulo, valor),
          ),
        );

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: tema.secondaryBackground,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: tema.alternate, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          Row(children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: cor,
              child: Text(a.brinco > 0 ? '${a.brinco}' : '?',
                  style: GoogleFonts.readexPro(
                      color: corTextoSobre(cor),
                      fontSize: a.brinco > 9999 ? 9 : 12,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tituloNomeBrinco(a.nome, a.brinco),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.readexPro(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  SeloStatus(textoStatus(a), cor: corSeloAnimal(a)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            dado('Último parto', fmtData(a.inicioLactacao)),
            const SizedBox(width: 8),
            dado('Dias pós-parto',
                posicao.diasPosParto == null ? '' : '${posicao.diasPosParto}'),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            dado('Última IA', fmtData(a.ia)),
            const SizedBox(width: 8),
            dado('Parto previsto', fmtData(posicao.partoPrevistoEfetivo)),
          ]),
          const SizedBox(height: 12),
          if (alerta != null)
            AvisoAlertaRoda('Fora da fase: $alerta')
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppTokens.positivo.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppTokens.radiusSmall),
              ),
              child: Text('Na fase certa: ${kNomeFase[posicao.faixa]}',
                  style: GoogleFonts.readexPro(
                      color: AppTokens.positivo,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600)),
            ),
          const SizedBox(height: 12),
          BotoesAcaoRoda(
            posicao: posicao,
            acoes: acoesPara(posicao, diasDg: diasDg),
            aoAgir: (acao) => Navigator.of(context).pop(acao),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pop('prontuario'),
              icon: const Icon(Icons.assignment_rounded, size: 18),
              label: const Text('Abrir prontuário'),
            ),
          ),
        ]),
      ),
    );
  }
}
