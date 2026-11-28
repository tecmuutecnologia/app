import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/roda_reproducao/ciclo_reproducao.dart';
import 'package:tecmuu/domain/roda_reproducao/tarefas_semana.dart';
import 'package:tecmuu/features/roda_reproducao/application/acoes_roda.dart';

final hoje = DateTime(2026, 11, 24);
DateTime ha(int d) => hoje.subtract(Duration(days: d));
DateTime daqui(int d) => hoje.add(Duration(days: d));

PosicaoRoda pos(String status,
        {String grupo = 'Vacas',
        DateTime? parto,
        DateTime? ia,
        DateTime? previsto,
        DateTime? pp}) =>
    calcularPosicao(
        AnimalRoda(
            id: '1',
            nome: 'X',
            brinco: 1,
            status: status,
            grupo: grupo,
            parto: parto,
            ia: ia,
            partoPrevisto: previsto,
            pp: pp),
        hoje)!;

void main() {
  test('por aba', () {
    expect(acoesPara(pos('Seca', previsto: daqui(2)), aba: AbaSemana.parir),
        [AcaoRoda.parto]);
    expect(acoesPara(pos('Prenha', previsto: daqui(62)), aba: AbaSemana.secar),
        [AcaoRoda.secagem]);
    expect(
        acoesPara(pos('Inseminada', ia: ha(35)), aba: AbaSemana.diagnostico),
        [AcaoRoda.pp, AcaoRoda.dgMais, AcaoRoda.dgMenos]);
    expect(acoesPara(pos('Inseminada', ia: ha(20)), aba: AbaSemana.cio),
        [AcaoRoda.fezCio, AcaoRoda.inseminar]);
    expect(acoesPara(pos('Vazia', parto: ha(30)), aba: AbaSemana.posParto),
        [AcaoRoda.exame]);
  });

  test('sem aba (faixa/folha/atrasadas): pelo alerta e depois pelo estado', () {
    expect(acoesPara(pos('Vazia', parto: ha(100))),
        [AcaoRoda.fezCio, AcaoRoda.inseminar]);
    expect(acoesPara(pos('Inseminada', ia: ha(70))),
        [AcaoRoda.pp, AcaoRoda.dgMais, AcaoRoda.dgMenos]);
    expect(acoesPara(pos('Prenha', previsto: daqui(40))), [AcaoRoda.secagem]);
    expect(acoesPara(pos('Seca', previsto: ha(5))), [AcaoRoda.parto]);
    expect(acoesPara(pos('Vazia', parto: ha(10))),
        [AcaoRoda.fezCio, AcaoRoda.inseminar]);
    expect(acoesPara(pos('Inseminada', ia: ha(5))), [AcaoRoda.fezCio]);
    expect(acoesPara(pos('Prenha', previsto: daqui(200))), [AcaoRoda.secagem]);
    expect(
        acoesPara(pos('Prenha', grupo: 'Novilhas', previsto: daqui(20))),
        [AcaoRoda.parto]);
  });

  test('inseminada sem DG perto do parto oferece Parto', () {
    expect(acoesPara(pos('Inseminada', ia: ha(290))),
        [AcaoRoda.parto, AcaoRoda.dgMenos]);
    expect(acoesPara(pos('Inseminada', ia: ha(275)), aba: AbaSemana.parir),
        [AcaoRoda.parto]);
  });

  test('DG+ só habilita depois do PP', () {
    expect(dgMaisHabilitado(pos('Inseminada', ia: ha(35))), isFalse);
    expect(dgMaisHabilitado(pos('Inseminada PP', ia: ha(35))), isTrue);
    expect(dgMaisHabilitado(pos('Inseminada', ia: ha(35), pp: ha(3))), isTrue);
  });

  test('textos de alerta', () {
    expect(textoAlerta(pos('Vazia', parto: ha(100))),
        'Sem cobertura há 100 dias (ideal até 83)');
    expect(textoAlerta(pos('Inseminada', ia: ha(70))),
        '70 dias da IA sem diagnóstico');
    expect(textoAlerta(pos('Prenha', previsto: daqui(50))),
        'Secagem atrasada 10 dias');
    expect(textoAlerta(pos('Seca', previsto: ha(5))), 'Parto atrasado 5 dias');
    expect(textoAlerta(pos('Vazia', parto: ha(400))),
        'Fora do ciclo: 400 dias desde o parto');
    expect(textoAlerta(pos('Vazia', parto: ha(10))), isNull);
  });
}
