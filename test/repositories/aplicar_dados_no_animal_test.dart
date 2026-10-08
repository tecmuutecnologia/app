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
      final animal = AnimalEntity(nomeAnimal: 'Mimosa', racaAnimal: 'Holandesa');

      aplicarDadosNoAnimal(animal, {'nomeAnimal': 'Estrela'});

      expect(animal.racaAnimal, 'Holandesa');
    });
  });
}
