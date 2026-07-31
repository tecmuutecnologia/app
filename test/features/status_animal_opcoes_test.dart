import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/reference_entities.dart';
import 'package:tecmuu/features/animais/application/status_animal_opcoes.dart';

/// As opções do dropdown "Status" no cadastro de vaca/novilha saíam de uma
/// closure dentro do build que recebia a lista de status como `dynamic`. Duas
/// consequências, ambas reproduzidas no emulador:
///
/// 1. `dynamic` apagava o tipo: `.map((e) => e.descricao)` virava
///    `List<dynamic>`, e o dropdown espera `List<String>` — o build quebrava a
///    cada frame e a tela ficava cinza.
/// 2. As datas eram comparadas com `!` (`_datePicked2! > _datePicked3!`), então
///    preencher só uma delas estourava null check.
void main() {
  final referencia = [
    StatusAnimalEntity(statusId: 1, descricao: 'Vazia'),
    StatusAnimalEntity(statusId: 2, descricao: 'Inseminada'),
    StatusAnimalEntity(statusId: 3, descricao: 'Prenha'),
    StatusAnimalEntity(statusId: 4, descricao: 'Seca'),
    StatusAnimalEntity(statusId: 5, descricao: 'Inseminada PP'),
    StatusAnimalEntity(statusId: 6, descricao: 'Pré Parto'),
  ];

  group('opcoesStatusAnimal', () {
    test('só último parto preenchido devolve List<String>, sem estourar', () {
      final opcoes = opcoesStatusAnimal(
        statusDisponiveis: referencia,
        ultimoParto: DateTime(2026, 4, 30),
        ultimaInseminacao: null,
      );

      // O caso exato do bug: vaca com parto e sem inseminação.
      expect(opcoes, ['Vazia']);
      // O tipo é o que o dropdown exige — `List<dynamic>` não serve.
      expect(opcoes, isA<List<String>>());
    });

    test('só última inseminação preenchida: novilha não pode ficar Seca', () {
      final novilha = opcoesStatusAnimal(
        statusDisponiveis: referencia,
        ultimoParto: null,
        ultimaInseminacao: DateTime(2026, 4, 30),
        grupo: 'Novilhas',
      );
      final vaca = opcoesStatusAnimal(
        statusDisponiveis: referencia,
        ultimoParto: null,
        ultimaInseminacao: DateTime(2026, 4, 30),
        grupo: 'Vacas',
      );

      expect(novilha, isNot(contains('Seca')));
      expect(vaca, contains('Seca'));
    });

    test('parto depois da inseminação: a vaca está vazia', () {
      expect(
        opcoesStatusAnimal(
          statusDisponiveis: referencia,
          ultimoParto: DateTime(2026, 4, 30),
          ultimaInseminacao: DateTime(2026, 1, 10),
        ),
        ['Vazia'],
      );
    });

    test('inseminação depois do parto: opções de animal coberto', () {
      final opcoes = opcoesStatusAnimal(
        statusDisponiveis: referencia,
        ultimoParto: DateTime(2026, 1, 10),
        ultimaInseminacao: DateTime(2026, 4, 30),
      );

      expect(opcoes, containsAll(['Inseminada', 'Prenha', 'Seca']));
      expect(opcoes, isNot(contains('Vazia')));
    });

    test('nenhuma data preenchida: Vazia', () {
      expect(
        opcoesStatusAnimal(statusDisponiveis: referencia),
        ['Vazia'],
      );
    });

    test('tabela de referência vazia ainda devolve opções utilizáveis', () {
      // Instalação nova offline: as tabelas de referência podem não ter sido
      // baixadas. Sem fallback o dropdown ficaria sem nenhuma opção, com um
      // valor selecionado que não existe — outra tela cinza.
      expect(
        opcoesStatusAnimal(
          statusDisponiveis: const [],
          ultimoParto: DateTime(2026, 4, 30),
        ),
        ['Vazia'],
      );
      expect(
        opcoesStatusAnimal(
          statusDisponiveis: const [],
          ultimoParto: DateTime(2026, 1, 10),
          ultimaInseminacao: DateTime(2026, 4, 30),
        ),
        containsAll(['Inseminada', 'Prenha']),
      );
    });

    test('o status sugerido é sempre uma das opções oferecidas', () {
      // O formulário pré-seleciona um status quando o usuário escolhe uma data.
      // Se esse valor não estiver entre as opções, o campo aparece vazio.
      final casos = <List<DateTime?>>[
        [null, null],
        [DateTime(2026, 4, 30), null],
        [null, DateTime(2026, 4, 30)],
        [DateTime(2026, 4, 30), DateTime(2026, 1, 10)],
        [DateTime(2026, 1, 10), DateTime(2026, 4, 30)],
      ];

      for (final caso in casos) {
        final parto = caso[0];
        final insem = caso[1];
        expect(
          opcoesStatusAnimal(
            statusDisponiveis: referencia,
            ultimoParto: parto,
            ultimaInseminacao: insem,
          ),
          contains(
              statusSugerido(ultimoParto: parto, ultimaInseminacao: insem)),
          reason: 'parto=$parto inseminação=$insem',
        );
      }
    });

    test('descrição nula na referência não entra na lista', () {
      final opcoes = opcoesStatusAnimal(
        statusDisponiveis: [
          StatusAnimalEntity(statusId: 1, descricao: 'Vazia'),
          StatusAnimalEntity(statusId: 2, descricao: null),
        ],
        ultimoParto: DateTime(2026, 4, 30),
      );

      expect(opcoes, ['Vazia']);
    });
  });
}
