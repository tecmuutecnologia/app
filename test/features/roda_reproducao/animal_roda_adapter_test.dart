import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/animal_entity.dart';
import 'package:tecmuu/features/roda_reproducao/application/animal_roda_adapter.dart';

void main() {
  group('animalRodaDe', () {
    test('converte datas dd/MM/yyyy e campos básicos', () {
      final e = AnimalEntity(
        nomeAnimal: 'Mimosa',
        brincoAnimal: 12,
        status: 'Prenha',
        grupoAnimal: 'Vacas',
        dtUltimoParto: '10/01/2026',
        dtUltimaInseminacao: '05/03/2026',
        dtPartoPrevisto: '09/12/2026',
        dtDgMais: '15/04/2026',
        dtPP: '01/04/2026',
        dtInducaoLactacao: DateTime(2025, 6, 1, 14, 30),
      )..id = 42;
      final a = animalRodaDe(e);
      expect(a.id, '42');
      expect(a.nome, 'Mimosa');
      expect(a.brinco, 12);
      expect(a.status, 'Prenha');
      expect(a.grupo, 'Vacas');
      expect(a.parto, DateTime(2026, 1, 10));
      expect(a.ia, DateTime(2026, 3, 5));
      expect(a.partoPrevisto, DateTime(2026, 12, 9));
      expect(a.dgMais, DateTime(2026, 4, 15));
      expect(a.pp, DateTime(2026, 4, 1));
      expect(a.inducao, DateTime(2025, 6, 1));
    });

    test('aceita dia e mês sem zero à esquerda, rejeita dia inexistente', () {
      final a = animalRodaDe(AnimalEntity(
          dtUltimoParto: '5/3/2026', dtUltimaInseminacao: '31/02/2026'));
      expect(a.parto, DateTime(2026, 3, 5));
      expect(a.ia, isNull);
    });

    test('vazio, sentinela 31/12/2050 e lixo viram null', () {
      final e = AnimalEntity(
        dtUltimoParto: '',
        dtUltimaInseminacao: '31/12/2050',
        dtPartoPrevisto: 'abc',
        dtDgMais: '01/01/1900',
      );
      final a = animalRodaDe(e);
      expect(a.parto, isNull);
      expect(a.ia, isNull);
      expect(a.partoPrevisto, isNull);
      expect(a.dgMais, isNull);
      expect(a.nome, '');
      expect(a.status, '');
    });
  });

  group('rotuloBrinco', () {
    test('até 4 dígitos inteiro', () {
      expect(rotuloBrinco(7, 'x'), '7');
      expect(rotuloBrinco(1234, 'x'), '1234');
    });
    test('5+ dígitos mostra os 4 últimos', () {
      expect(rotuloBrinco(850808, 'x'), '0808');
      expect(rotuloBrinco(78787, 'x'), '8787');
    });
    test('sem brinco usa a inicial do nome', () {
      expect(rotuloBrinco(0, 'mimosa'), 'M');
      expect(rotuloBrinco(0, '  '), '?');
    });
  });
}
