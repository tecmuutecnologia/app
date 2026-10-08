import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/schema/structs/animais_produtores_struct.dart';
import 'package:tecmuu/features/secas/application/filtros_secas.dart';

/// Structs sem `uidTecnicoPropriedade`: a filtragem por propriedade passou a
/// acontecer na ORIGEM (consulta indexada do ObjectBox), entao a regra por aba
/// nao toca DocumentReference e roda sem Firebase.
AnimaisProdutoresStruct animal({
  String nome = 'Mimosa',
  int brinco = 7,
  String? status,
  String? grupo,
  DateTime? comparar,
  DateTime? inducao,
}) =>
    AnimaisProdutoresStruct(
      nomeAnimal: nome,
      brincoAnimal: brinco,
      status: status,
      grupoAnimal: grupo,
      compararDtUltimaInseminacao: comparar,
      dtInducaoLactacao: inducao,
    );

final sentinela = DateTime(2050, 12, 31);

List<String> nomes(List<AnimaisProdutoresStruct> l) =>
    l.map((e) => e.nomeAnimal).toList();

void main() {
  group('data-sentinela 31/12/2050', () {
    test('reconhece a sentinela', () {
      expect(temDataSentinela(sentinela), isTrue);
    });

    test('data comum nao e sentinela', () {
      expect(temDataSentinela(DateTime(2026, 5, 26)), isFalse);
    });

    test('nulo nao e sentinela', () {
      // Cuidado ao ler isto como comportamento de tela: o struct NUNCA devolve
      // nulo aqui — `compararDtUltimaInseminacao` tem 31/12/2050 como default,
      // entao animal sem data cai como sentinela e fica fora da lista.
      expect(temDataSentinela(null), isFalse);
    });
  });

  group('aba Vacas secas', () {
    test('mantem vaca seca com data real', () {
      final lista = [
        animal(nome: 'Seca', grupo: 'Vacas', status: 'Seca', comparar: DateTime(2026, 5, 26)),
        animal(nome: 'Prenha', grupo: 'Vacas', status: 'Prenha'),
        animal(nome: 'Novilha', grupo: 'Novilhas', status: 'Seca'),
      ];

      final r = animaisDaAba(lista, aba: AbaSecas.vacasSecas);

      expect(nomes(r), ['Seca']);
    });

    test('descarta quem tem a data-sentinela', () {
      final lista = [
        animal(nome: 'Sentinela', grupo: 'Vacas', status: 'Seca', comparar: sentinela),
      ];

      expect(animaisDaAba(lista, aba: AbaSecas.vacasSecas), isEmpty);
    });
  });

  group('aba Pre Parto', () {
    test('mantem apenas status Pre Parto com data real', () {
      final lista = [
        animal(nome: 'PP', status: 'Pré Parto', comparar: DateTime(2026, 1, 1)),
        animal(nome: 'Seca', grupo: 'Vacas', status: 'Seca'),
      ];

      expect(nomes(animaisDaAba(lista, aba: AbaSecas.preParto)), ['PP']);
    });
  });

  group('aba Inducao Lactacao', () {
    test('mantem quem tem data de inducao', () {
      final lista = [
        animal(nome: 'Induzida', inducao: DateTime(2026, 3, 1)),
        animal(nome: 'Sem inducao'),
      ];

      expect(nomes(animaisDaAba(lista, aba: AbaSecas.inducaoLactacao)),
          ['Induzida']);
    });
  });

  group('aba Descarte', () {
    test('mantem apenas descartados', () {
      final lista = [
        animal(nome: 'Fora', status: 'Descarte'),
        animal(nome: 'Dentro', status: 'Vazia'),
      ];

      expect(nomes(animaisDaAba(lista, aba: AbaSecas.descarte)), ['Fora']);
    });
  });

  group('busca', () {
    test('casa por nome ignorando maiuscula', () {
      final lista = [
        animal(nome: 'Bonita', status: 'Descarte'),
        animal(nome: 'Aurora', status: 'Descarte'),
      ];

      expect(nomes(animaisDaAba(lista, aba: AbaSecas.descarte, busca: 'bonit')),
          ['Bonita']);
    });

    test('casa por brinco', () {
      final lista = [
        animal(nome: 'Bonita', brinco: 47, status: 'Descarte'),
        animal(nome: 'Aurora', brinco: 12, status: 'Descarte'),
      ];

      expect(nomes(animaisDaAba(lista, aba: AbaSecas.descarte, busca: '47')),
          ['Bonita']);
    });

    test('busca vazia nao filtra nada', () {
      final lista = [
        animal(nome: 'Bonita', status: 'Descarte'),
        animal(nome: 'Aurora', status: 'Descarte'),
      ];

      expect(animaisDaAba(lista, aba: AbaSecas.descarte, busca: ''), hasLength(2));
    });
  });
}
