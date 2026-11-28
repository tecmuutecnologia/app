import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/roda_reproducao/ciclo_reproducao.dart';

final hoje = DateTime(2026, 11, 24);
DateTime ha(int dias) => hoje.subtract(Duration(days: dias));
DateTime daqui(int dias) => hoje.add(Duration(days: dias));

AnimalRoda animal({
  String status = 'Vazia',
  String grupo = 'Vacas',
  DateTime? parto,
  DateTime? ia,
  DateTime? partoPrevisto,
  DateTime? dgMais,
  DateTime? pp,
  DateTime? inducao,
}) =>
    AnimalRoda(
      id: 'a1',
      nome: 'Mimosa',
      brinco: 12,
      status: status,
      grupo: grupo,
      parto: parto,
      ia: ia,
      partoPrevisto: partoPrevisto,
      dgMais: dgMais,
      pp: pp,
      inducao: inducao,
    );

void main() {
  group('faseDoDia', () {
    test('limites das faixas', () {
      expect(faseDoDia(0), FaseRoda.posParto);
      expect(faseDoDia(82), FaseRoda.posParto);
      expect(faseDoDia(83), FaseRoda.cobertura);
      expect(faseDoDia(142), FaseRoda.cobertura);
      expect(faseDoDia(143), FaseRoda.prenhe);
      expect(faseDoDia(304), FaseRoda.prenhe);
      expect(faseDoDia(305), FaseRoda.seca);
      expect(faseDoDia(364), FaseRoda.seca);
    });
  });

  group('faseEstado (cor)', () {
    test('status → fase', () {
      expect(animal(status: 'Vazia').faseEstado, FaseRoda.posParto);
      expect(animal(status: 'Aborto').faseEstado, FaseRoda.posParto);
      expect(animal(status: 'Inseminada').faseEstado, FaseRoda.cobertura);
      expect(animal(status: 'Inseminada PP').faseEstado, FaseRoda.prenhe);
      expect(animal(status: 'Prenha').faseEstado, FaseRoda.prenhe);
      expect(animal(status: 'Seca').faseEstado, FaseRoda.seca);
      expect(animal(status: 'Pré Parto').faseEstado, FaseRoda.seca);
      expect(animal(status: 'Pré-parto').faseEstado, FaseRoda.seca);
    });
  });

  group('inseminada com PP conta como prenhe', () {
    test('status Inseminada PP: azul, sem alerta de DG atrasado', () {
      final a = animal(status: 'Inseminada PP', ia: ha(90));
      expect(a.prenhe, isTrue);
      expect(a.semDiagnostico, isFalse);
      final p = calcularPosicao(a, hoje)!;
      expect(p.alerta, isNull);
    });

    test('Inseminada com PP registrado depois da IA atual também conta', () {
      final a = animal(status: 'Inseminada', ia: ha(60), pp: ha(20));
      expect(a.faseEstado, FaseRoda.prenhe);
      expect(a.semDiagnostico, isFalse);
    });

    test('PP de um ciclo anterior (antes da IA atual) não conta', () {
      final a = animal(status: 'Inseminada', ia: ha(30), pp: ha(200));
      expect(a.faseEstado, FaseRoda.cobertura);
      expect(a.semDiagnostico, isTrue);
    });

    test('vaca Inseminada PP passada do dia de secar → secagem atrasada', () {
      // IA há 240 dias → dia 325 do ciclo (> 305 + 7).
      final p = calcularPosicao(
          animal(status: 'Inseminada PP', ia: ha(240)), hoje)!;
      expect(p.alerta, AlertaRoda.secagemAtrasada);
    });
  });

  group('calcularPosicao — vazias', () {
    test('pariu há 10 dias → dia 10, pós-parto, sem alerta', () {
      final p = calcularPosicao(animal(parto: ha(10)), hoje)!;
      expect(p.dia, 10);
      expect(p.faixa, FaseRoda.posParto);
      expect(p.alerta, isNull);
      expect(p.naRoda, isTrue);
      expect(p.diasPosParto, 10);
    });

    test('vazia há 90 dias → sem cobertura', () {
      final p = calcularPosicao(animal(parto: ha(90)), hoje)!;
      expect(p.dia, 90);
      expect(p.faixa, FaseRoda.cobertura);
      expect(p.alerta, AlertaRoda.semCobertura);
    });

    test('vazia há 83 dias ainda não é alerta', () {
      expect(calcularPosicao(animal(parto: ha(83)), hoje)!.alerta, isNull);
    });

    test('vazia há 400 dias → fora do ciclo', () {
      final p = calcularPosicao(animal(parto: ha(400)), hoje)!;
      expect(p.naRoda, isFalse);
      expect(p.alerta, AlertaRoda.foraDoCiclo);
    });

    test('aborto não muda a âncora: segue pelo último parto', () {
      final p =
          calcularPosicao(animal(status: 'Aborto', parto: ha(200)), hoje)!;
      expect(p.dia, 200);
      expect(p.alerta, AlertaRoda.semCobertura);
    });

    test('indução mais recente que o parto vale como parto', () {
      final p = calcularPosicao(
          animal(parto: ha(500), inducao: ha(20)), hoje)!;
      expect(p.dia, 20);
      expect(p.naRoda, isTrue);
      expect(p.alerta, isNull);
    });

    test('indução mais antiga que o parto é ignorada', () {
      final p = calcularPosicao(
          animal(parto: ha(30), inducao: ha(300)), hoje)!;
      expect(p.dia, 30);
    });

    test('vazia sem parto nem indução → fora da roda (null)', () {
      expect(calcularPosicao(animal(), hoje), isNull);
    });
  });

  group('calcularPosicao — cobertas', () {
    test('prenhe com parto previsto em 5 dias → dia 360, faixa seca', () {
      final p = calcularPosicao(
          animal(status: 'Prenha', partoPrevisto: daqui(5), ia: ha(275)),
          hoje)!;
      expect(p.dia, 360);
      expect(p.faixa, FaseRoda.seca);
    });

    test('sem parto previsto usa IA + 280', () {
      final p =
          calcularPosicao(animal(status: 'Prenha', ia: ha(100)), hoje)!;
      expect(p.dia, 185);
      expect(p.partoPrevistoEfetivo, ha(100).add(const Duration(days: 280)));
      expect(p.diasPosIa, 100);
    });

    test('inseminada há 70 dias sem DG → DG atrasado', () {
      final p =
          calcularPosicao(animal(status: 'Inseminada', ia: ha(70)), hoje)!;
      expect(p.alerta, AlertaRoda.dgAtrasado);
    });

    test('inseminada há 60 dias ainda não é alerta', () {
      final p =
          calcularPosicao(animal(status: 'Inseminada', ia: ha(60)), hoje)!;
      expect(p.alerta, isNull);
    });

    test('DG+ anterior à IA atual não conta como diagnóstico', () {
      final a = animal(status: 'Inseminada', ia: ha(30), dgMais: ha(200));
      expect(a.semDiagnostico, isTrue);
      final b = animal(status: 'Inseminada', ia: ha(50), dgMais: ha(10));
      expect(b.semDiagnostico, isFalse);
    });

    test('vaca prenhe no dia 313 → secagem atrasada', () {
      final p = calcularPosicao(
          animal(status: 'Prenha', partoPrevisto: daqui(52)), hoje)!;
      expect(p.dia, 313);
      expect(p.alerta, AlertaRoda.secagemAtrasada);
    });

    test('vaca prenhe no dia 312 ainda não é alerta', () {
      final p = calcularPosicao(
          animal(status: 'Prenha', partoPrevisto: daqui(53)), hoje)!;
      expect(p.alerta, isNull);
    });

    test('novilha prenhe no dia 330 não tem alerta de secagem', () {
      final p = calcularPosicao(
          animal(
              status: 'Prenha', grupo: 'Novilhas', partoPrevisto: daqui(35)),
          hoje)!;
      expect(p.alerta, isNull);
      expect(p.animal.novilha, isTrue);
    });

    test('seca com parto previsto há 4 dias → parto atrasado', () {
      final p = calcularPosicao(
          animal(status: 'Seca', partoPrevisto: ha(4)), hoje)!;
      expect(p.alerta, AlertaRoda.partoAtrasado);
      expect(p.naRoda, isTrue);
      expect(p.dia, 364);
    });

    test('seca com parto previsto há 3 dias → sem alerta', () {
      final p = calcularPosicao(
          animal(status: 'Seca', partoPrevisto: ha(3)), hoje)!;
      expect(p.alerta, isNull);
    });

    test('coberta sem IA e sem parto previsto → null', () {
      expect(calcularPosicao(animal(status: 'Prenha'), hoje), isNull);
    });
  });

  group('datas impossíveis', () {
    test('parto no futuro → fora da roda (null)', () {
      expect(calcularPosicao(animal(parto: daqui(5)), hoje), isNull);
    });
    test('parto previsto a mais de 365 dias → fora da roda (null)', () {
      expect(
          calcularPosicao(
              animal(status: 'Prenha', partoPrevisto: daqui(400)), hoje),
          isNull);
    });
  });

  group('elegibilidade', () {
    test('bezerra, descarte e novilha vazia ficam fora', () {
      expect(
          calcularPosicao(
              animal(grupo: 'Bezerras', status: 'Vazia', parto: ha(10)), hoje),
          isNull);
      expect(
          calcularPosicao(animal(status: 'Descarte', parto: ha(10)), hoje),
          isNull);
      expect(
          calcularPosicao(
              animal(grupo: 'Novilhas', status: 'Vazia', parto: ha(10)), hoje),
          isNull);
    });

    test('novilha com grupo no singular também é novilha', () {
      final p = calcularPosicao(
          animal(grupo: 'Novilha', status: 'Inseminada', ia: ha(10)), hoje)!;
      expect(p.animal.novilha, isTrue);
    });
  });
}
