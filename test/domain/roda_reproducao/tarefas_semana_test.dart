import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/roda_reproducao/ciclo_reproducao.dart';
import 'package:tecmuu/domain/roda_reproducao/tarefas_semana.dart';

final hoje = DateTime(2026, 11, 24);
DateTime ha(int dias) => hoje.subtract(Duration(days: dias));
DateTime daqui(int dias) => hoje.add(Duration(days: dias));

PosicaoRoda pos({
  String status = 'Vazia',
  String grupo = 'Vacas',
  DateTime? parto,
  DateTime? ia,
  DateTime? partoPrevisto,
  DateTime? dgMais,
  int brinco = 1,
}) =>
    calcularPosicao(
        AnimalRoda(
          id: '$brinco',
          nome: 'A$brinco',
          brinco: brinco,
          status: status,
          grupo: grupo,
          parto: parto,
          ia: ia,
          partoPrevisto: partoPrevisto,
          dgMais: dgMais,
        ),
        hoje)!;

void main() {
  test('rótulos das abas', () {
    expect(AbaSemana.values.map(rotuloAba).toList(), [
      'Parir',
      'Secar',
      'Diagnóstico',
      'Cio 21d',
      'Pós-parto 30d',
      'Atrasadas',
    ]);
  });

  group('parir', () {
    test('seca com parto em 5 dias → parir', () {
      expect(abasDe(pos(status: 'Seca', partoPrevisto: daqui(5)), diasDg: 30),
          contains(AbaSemana.parir));
    });
    test('parto em 7 dias → parir; em 8 → não', () {
      expect(abasDe(pos(status: 'Seca', partoPrevisto: daqui(7)), diasDg: 30),
          contains(AbaSemana.parir));
      expect(abasDe(pos(status: 'Seca', partoPrevisto: daqui(8)), diasDg: 30),
          isNot(contains(AbaSemana.parir)));
    });
    test('parto atrasado também está em parir', () {
      expect(abasDe(pos(status: 'Seca', partoPrevisto: ha(10)), diasDg: 30),
          contains(AbaSemana.parir));
    });
    test('inseminada sem DG perto do parto também está em parir', () {
      expect(abasDe(pos(status: 'Inseminada', ia: ha(275)), diasDg: 30),
          contains(AbaSemana.parir));
      expect(abasDe(pos(status: 'Inseminada', ia: ha(200)), diasDg: 30),
          isNot(contains(AbaSemana.parir)));
    });
  });

  group('secar', () {
    test('vaca prenhe no dia 298 → secar; 297 → não', () {
      expect(
          abasDe(pos(status: 'Prenha', partoPrevisto: daqui(67)), diasDg: 30),
          contains(AbaSemana.secar));
      expect(
          abasDe(pos(status: 'Prenha', partoPrevisto: daqui(68)), diasDg: 30),
          isNot(contains(AbaSemana.secar)));
    });
    test('novilha prenhe no dia 300 → não', () {
      expect(
          abasDe(
              pos(
                  status: 'Prenha',
                  grupo: 'Novilhas',
                  partoPrevisto: daqui(65)),
              diasDg: 30),
          isNot(contains(AbaSemana.secar)));
    });
  });

  group('diagnóstico', () {
    test('usa diasDg da propriedade', () {
      expect(abasDe(pos(status: 'Inseminada', ia: ha(31)), diasDg: 30),
          contains(AbaSemana.diagnostico));
      expect(abasDe(pos(status: 'Inseminada', ia: ha(30)), diasDg: 30),
          contains(AbaSemana.diagnostico));
      expect(abasDe(pos(status: 'Inseminada', ia: ha(29)), diasDg: 30),
          isNot(contains(AbaSemana.diagnostico)));
    });
    test('novilha inseminada também', () {
      expect(
          abasDe(pos(status: 'Inseminada', grupo: 'Novilhas', ia: ha(40)),
              diasDg: 30),
          contains(AbaSemana.diagnostico));
    });
    test('com DG+ deste ciclo → não', () {
      expect(
          abasDe(pos(status: 'Inseminada', ia: ha(40), dgMais: ha(5)),
              diasDg: 30),
          isNot(contains(AbaSemana.diagnostico)));
    });
  });

  group('cio 21d', () {
    test('18 e 24 dias → sim; 17 e 25 → não', () {
      for (final d in [18, 24]) {
        expect(abasDe(pos(status: 'Inseminada', ia: ha(d)), diasDg: 30),
            contains(AbaSemana.cio),
            reason: '$d');
      }
      for (final d in [17, 25]) {
        expect(abasDe(pos(status: 'Inseminada', ia: ha(d)), diasDg: 30),
            isNot(contains(AbaSemana.cio)),
            reason: '$d');
      }
    });
  });

  group('pós-parto 30d', () {
    test('vazia 28..45 dias → sim; 27 e 46 → não', () {
      for (final d in [28, 45]) {
        expect(abasDe(pos(parto: ha(d)), diasDg: 30),
            contains(AbaSemana.posParto),
            reason: '$d');
      }
      for (final d in [27, 46]) {
        expect(abasDe(pos(parto: ha(d)), diasDg: 30),
            isNot(contains(AbaSemana.posParto)),
            reason: '$d');
      }
    });
  });

  test('atrasadas = qualquer alerta', () {
    expect(abasDe(pos(parto: ha(100)), diasDg: 30),
        contains(AbaSemana.atrasadas));
    expect(abasDe(pos(parto: ha(10)), diasDg: 30),
        isNot(contains(AbaSemana.atrasadas)));
  });

  test('agruparSemana: alertas primeiro, depois por dia', () {
    final a = pos(brinco: 1, status: 'Inseminada', ia: ha(45));
    final b = pos(brinco: 2, status: 'Inseminada', ia: ha(65)); // alerta
    final c = pos(brinco: 3, status: 'Inseminada', ia: ha(35));
    final g = agruparSemana([a, b, c], diasDg: 30);
    expect(g[AbaSemana.diagnostico]!.map((p) => p.animal.brinco).toList(),
        [2, 3, 1]);
    expect(g.keys.toSet(), AbaSemana.values.toSet());
  });

  test('contarPorEstado conta pela cor e ignora fora do ciclo', () {
    final c = contarPorEstado([
      pos(parto: ha(150)), // vazia na faixa prenhe → conta pós-parto
      pos(parto: ha(10)),
      pos(parto: ha(400)), // fora do ciclo
      pos(status: 'Prenha', ia: ha(100)),
    ]);
    expect(c[FaseRoda.posParto], 2);
    expect(c[FaseRoda.prenhe], 1);
    expect(c[FaseRoda.cobertura], 0);
    expect(c[FaseRoda.seca], 0);
  });

  test('naFaixa: animais posicionados na faixa, alertas primeiro', () {
    final ok = pos(brinco: 1, status: 'Prenha', ia: ha(100)); // dia 185
    final vazia = pos(brinco: 2, parto: ha(200)); // dia 200, alerta
    final fora = pos(brinco: 3, parto: ha(10));
    final r = naFaixa([ok, vazia, fora], FaseRoda.prenhe);
    expect(r.map((p) => p.animal.brinco).toList(), [2, 1]);
  });
}
