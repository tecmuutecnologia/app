import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/receituario/application/tratamento_orfao.dart';

TratamentoEntity _t({
  String? acaoLancada,
  String animal = 'tecnico/T/animaisProdutores/A1',
  String tipo = 'Liberada',
  String data = '19/10/2026',
  bool apagado = false,
}) =>
    TratamentoEntity(
      uidAcaoLancadaPath: acaoLancada,
      uidAnimalPath: animal,
      tipoAcao: tipo,
      dtAcaoTratamento: data,
    )..isDeleted = apagado;

void main() {
  bool casa(TratamentoEntity t) => ehTratamentoOrfaoDaAcao(
        t,
        animalPath: 'tecnico/T/animaisProdutores/A1',
        acao: 'Liberada',
        dataVisita: '19/10/2026',
        dataLancamento: DateTime(2026, 10, 19, 23, 10),
      );

  test('tratamento antigo sem vínculo, mesmo animal/ação/dia: é o órfão', () {
    expect(casa(_t()), isTrue);
  });

  test('casa também pela data da visita (calendário usa a data digitada)', () {
    expect(
        ehTratamentoOrfaoDaAcao(_t(data: '15/10/2026'),
            animalPath: 'tecnico/T/animaisProdutores/A1',
            acao: 'Liberada',
            dataVisita: '15/10/2026',
            dataLancamento: DateTime(2026, 10, 19)),
        isTrue);
  });

  test('com vínculo NÃO é órfão: a cascata normal já cuida dele', () {
    expect(casa(_t(acaoLancada: 'tecnico/T/acoes/X')), isFalse);
  });

  test('outro animal, outra ação ou outro dia NÃO casam', () {
    expect(casa(_t(animal: 'tecnico/T/animaisProdutores/A2')), isFalse);
    expect(casa(_t(tipo: 'IATF')), isFalse);
    expect(casa(_t(data: '18/10/2026')), isFalse);
  });

  test('já apagado NÃO casa', () {
    expect(casa(_t(apagado: true)), isFalse);
  });
}
