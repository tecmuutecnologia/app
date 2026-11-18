import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/data/objectbox/repositories/animal_repository.dart';

void main() {
  group('descarte', () {
    test('grava status, data e motivo do descarte', () {
      final animal = AnimalEntity(nomeAnimal: 'Mimosa', status: 'Vazia');

      aplicarDadosNoAnimal(animal, {
        'status': 'Descarte',
        'dtDescarteAnimal': '07/10/2026',
        'motivoDescarteAnimal': 'Baixa produção',
      });

      expect(animal.status, 'Descarte');
      expect(animal.dtDescarteAnimal, '07/10/2026');
      expect(animal.motivoDescarteAnimal, 'Baixa produção');
    });

    test('nao apaga data e motivo quando o update nao os menciona', () {
      final animal = AnimalEntity(
        status: 'Descarte',
        dtDescarteAnimal: '07/10/2026',
        motivoDescarteAnimal: 'Baixa produção',
      );

      aplicarDadosNoAnimal(animal, {'nomeAnimal': 'Mimosa'});

      expect(animal.dtDescarteAnimal, '07/10/2026');
      expect(animal.motivoDescarteAnimal, 'Baixa produção');
    });
  });

  group('campos gerais', () {
    test('troca o que veio no mapa', () {
      final animal = AnimalEntity(nomeAnimal: 'Antigo', brincoAnimal: 1);

      aplicarDadosNoAnimal(animal, {'nomeAnimal': 'Novo', 'brincoAnimal': 42});

      expect(animal.nomeAnimal, 'Novo');
      expect(animal.brincoAnimal, 42);
    });

    test('preserva o que nao veio', () {
      final animal =
          AnimalEntity(nomeAnimal: 'Mimosa', racaAnimal: 'Holandesa');

      aplicarDadosNoAnimal(animal, {'nomeAnimal': 'Estrela'});

      expect(animal.racaAnimal, 'Holandesa');
    });
  });

  group('dtInducaoLactacao', () {
    test('null explícito no mapa apaga a indução', () {
      final animal = AnimalEntity(dtInducaoLactacao: DateTime(2025, 8, 22));

      aplicarDadosNoAnimal(animal, {'dtInducaoLactacao': null});

      expect(animal.dtInducaoLactacao, isNull);
    });

    test('mapa que não menciona a indução a preserva', () {
      final inducao = DateTime(2025, 8, 22);
      final animal = AnimalEntity(dtInducaoLactacao: inducao);

      aplicarDadosNoAnimal(animal, {'status': 'Vazia'});

      expect(animal.dtInducaoLactacao, inducao);
    });
  });

  group('campos de baixa (venda)', () {
    test('chave presente com null limpa o campo', () {
      final animal = AnimalEntity(
        tipoBaixa: 'venda',
        valorVendaAnimal: 10,
        idVendaAtual: 'v1',
        statusAnterior: 'Prenha',
      );

      aplicarDadosNoAnimal(animal, {
        'tipoBaixa': null,
        'valorVendaAnimal': null,
        'idVendaAtual': null,
        'statusAnterior': null,
      });

      expect(animal.tipoBaixa, isNull);
      expect(animal.valorVendaAnimal, isNull);
      expect(animal.idVendaAtual, isNull);
      expect(animal.statusAnterior, isNull);
    });

    test('update sem as chaves preserva os campos de baixa', () {
      final animal = AnimalEntity(tipoBaixa: 'venda', valorVendaAnimal: 10);

      aplicarDadosNoAnimal(animal, {'nomeAnimal': 'Mimosa'});

      expect(animal.tipoBaixa, 'venda');
      expect(animal.valorVendaAnimal, 10);
    });

    test('grava todos os campos de baixa e aceita valor inteiro', () {
      final animal = AnimalEntity();

      aplicarDadosNoAnimal(animal, {
        'tipoBaixa': 'venda',
        'statusAnterior': 'Descarte',
        'idStatusAnteriorAnimal': 7,
        'dtVendaAnimal': '18/11/2026',
        'valorVendaAnimal': 1500,
        'idVendaAtual': 'v1',
        'motivoDescarteAnterior': 'Idade',
        'dtDescarteAnterior': '01/11/2026',
      });

      expect(animal.tipoBaixa, 'venda');
      expect(animal.statusAnterior, 'Descarte');
      expect(animal.idStatusAnteriorAnimal, 7);
      expect(animal.dtVendaAnimal, '18/11/2026');
      expect(animal.valorVendaAnimal, 1500.0);
      expect(animal.idVendaAtual, 'v1');
      expect(animal.motivoDescarteAnterior, 'Idade');
      expect(animal.dtDescarteAnterior, '01/11/2026');
    });
  });
}
