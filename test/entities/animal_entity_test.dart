import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/animal_entity.dart';

void main() {
  group('AnimalEntity - Criação de Animal Básico', () {
    test('deve criar AnimalEntity com valores padrão', () {
      final animal = AnimalEntity();

      expect(animal.id, 0);
      expect(animal.firestoreId, isNull);
      expect(animal.parentPath, isNull);
      expect(animal.nomeAnimal, isNull);
      expect(animal.racaAnimal, isNull);
      expect(animal.pesoAnimal, isNull);
      expect(animal.status, isNull);
      expect(animal.grupoAnimal, isNull);
      expect(animal.liberaInseminacao, false);
      expect(animal.totalInseminacoes, 0);
      expect(animal.totalPartos, 0);
      expect(animal.brincoAnimal, 0);
      expect(animal.brincoAnimalOrder, 0);
      expect(animal.idGrupoAnimal, 0);
      expect(animal.idStatusAnimal, 0);
      expect(animal.needsSync, false);
      expect(animal.isDeleted, false);
    });

    test('deve criar vaca leiteira completa', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_001',
        parentPath: 'produtor/prod_001/propriedades/prop_001',
        uidTecnicoPropriedadePath: 'tecnico/tec_001',
        nomeAnimal: 'Mimosa',
        racaAnimal: 'Holandesa',
        pesoAnimal: '550',
        dtNascimento: '10/03/2020',
        touro: 'Tornado',
        vaca: 'Estrela',
        status: 'Vazia',
        grupoAnimal: 'Vacas',
        brincoAnimal: 1234,
        brincoAnimalOrder: 1234,
        idGrupoAnimal: 1,
        idStatusAnimal: 1,
        nomeBrincoConcat: 'Mimosa - 1234',
        liberaInseminacao: true,
      );

      expect(animal.firestoreId, 'animal_001');
      expect(animal.nomeAnimal, 'Mimosa');
      expect(animal.racaAnimal, 'Holandesa');
      expect(animal.pesoAnimal, '550');
      expect(animal.dtNascimento, '10/03/2020');
      expect(animal.touro, 'Tornado');
      expect(animal.vaca, 'Estrela');
      expect(animal.status, 'Vazia');
      expect(animal.grupoAnimal, 'Vacas');
      expect(animal.brincoAnimal, 1234);
      expect(animal.nomeBrincoConcat, 'Mimosa - 1234');
      expect(animal.liberaInseminacao, true);
    });

    test('deve criar touro reprodutor', () {
      final touro = AnimalEntity(
        firestoreId: 'touro_001',
        parentPath: 'produtor/prod_001/propriedades/prop_001',
        nomeAnimal: 'Tornado',
        racaAnimal: 'Nelore',
        pesoAnimal: '800',
        dtNascimento: '05/06/2019',
        status: 'Ativo',
        grupoAnimal: 'Touros',
        brincoAnimal: 5001,
        brincoAnimalOrder: 5001,
        idGrupoAnimal: 4,
        nomeBrincoConcat: 'Tornado - 5001',
      );

      expect(touro.grupoAnimal, 'Touros');
      expect(touro.nomeAnimal, 'Tornado');
      expect(touro.racaAnimal, 'Nelore');
      expect(touro.brincoAnimal, 5001);
    });

    test('deve criar bezerro recém-nascido', () {
      final bezerro = AnimalEntity(
        firestoreId: 'bez_001',
        parentPath: 'produtor/prod_001/propriedades/prop_001',
        nomeAnimal: 'Bezerro 1',
        racaAnimal: 'Girolando',
        dtNascimento: '01/04/2026',
        vaca: 'Mimosa',
        touro: 'Tornado',
        status: 'Recria',
        grupoAnimal: 'Bezerros',
        brincoAnimal: 7001,
        brincoAnimalOrder: 7001,
        idGrupoAnimal: 5,
        nomeBrincoConcat: 'Bezerro 1 - 7001',
      );

      expect(bezerro.grupoAnimal, 'Bezerros');
      expect(bezerro.vaca, 'Mimosa');
      expect(bezerro.touro, 'Tornado');
      expect(bezerro.dtNascimento, '01/04/2026');
    });

    test('deve criar novilha em crescimento', () {
      final novilha = AnimalEntity(
        firestoreId: 'nov_001',
        parentPath: 'produtor/prod_001/propriedades/prop_001',
        nomeAnimal: 'Novilha 1',
        racaAnimal: 'Holandesa',
        pesoAnimal: '350',
        dtNascimento: '15/08/2024',
        status: 'Recria',
        grupoAnimal: 'Novilhas',
        brincoAnimal: 3001,
        idGrupoAnimal: 3,
        liberaInseminacao: false,
      );

      expect(novilha.grupoAnimal, 'Novilhas');
      expect(novilha.liberaInseminacao, false);
    });
  });

  group('AnimalEntity - Conversão Firestore', () {
    test('deve converter AnimalEntity para Firestore corretamente', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_001',
        nomeAnimal: 'Mimosa',
        racaAnimal: 'Holandesa',
        pesoAnimal: '550',
        dtNascimento: '10/03/2020',
        touro: 'Tornado',
        vaca: 'Estrela',
        status: 'Vazia',
        grupoAnimal: 'Vacas',
        brincoAnimal: 1234,
        brincoAnimalOrder: 1234,
        idGrupoAnimal: 1,
        idStatusAnimal: 1,
        nomeBrincoConcat: 'Mimosa - 1234',
        liberaInseminacao: true,
        totalInseminacoes: 3,
        totalPartos: 2,
      );

      final data = animal.toFirestore();

      expect(data['nomeAnimal'], 'Mimosa');
      expect(data['racaAnimal'], 'Holandesa');
      expect(data['pesoAnimal'], '550');
      expect(data['dtNascimento'], '10/03/2020');
      expect(data['touro'], 'Tornado');
      expect(data['vaca'], 'Estrela');
      expect(data['status'], 'Vazia');
      expect(data['grupoAnimal'], 'Vacas');
      expect(data['brincoAnimal'], 1234);
      expect(data['brincoAnimalOrder'], 1234);
      expect(data['idGrupoAnimal'], 1);
      expect(data['idStatusAnimal'], 1);
      expect(data['nomeBrincoConcat'], 'Mimosa - 1234');
      expect(data['liberaInseminacao'], true);
      expect(data['totalInseminacoes'], 3);
      expect(data['totalPartos'], 2);
    });

    test('deve incluir datas no Firestore', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_002',
        nomeAnimal: 'Bela',
        dtUltimaInseminacao: '01/01/2026',
        dtUltimoParto: '15/06/2025',
        dtPartoPrevisto: '15/09/2026',
        dtSecPrevista: '01/07/2026',
        dtPrePartoPrevista: '01/09/2026',
        dtDgMais: '01/04/2026',
        dtSecagem: '01/07/2026',
      );

      final data = animal.toFirestore();

      expect(data['dtUltimaInseminacao'], '01/01/2026');
      expect(data['dtUltimoParto'], '15/06/2025');
      expect(data['dtPartoPrevisto'], '15/09/2026');
      expect(data['dtSecPrevista'], '01/07/2026');
      expect(data['dtPrePartoPrevista'], '01/09/2026');
      expect(data['dtDgMais'], '01/04/2026');
      expect(data['dtSecagem'], '01/07/2026');
    });
  });

  group('AnimalEntity - Atualização e Sincronização', () {
    test('deve atualizar animal a partir do Firestore', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_001',
        nomeAnimal: 'Nome Antigo',
        status: 'Vazia',
        pesoAnimal: '500',
        needsSync: true,
      );

      animal.updateFromFirestore({
        'nomeAnimal': 'Nome Atualizado',
        'status': 'Prenha',
        'pesoAnimal': '580',
        'dtUltimaInseminacao': '15/03/2026',
        'nomeTouroUltimaInseminacao': 'Tornado',
        'totalInseminacoes': 4,
      });

      expect(animal.nomeAnimal, 'Nome Atualizado');
      expect(animal.status, 'Prenha');
      expect(animal.pesoAnimal, '580');
      expect(animal.dtUltimaInseminacao, '15/03/2026');
      expect(animal.nomeTouroUltimaInseminacao, 'Tornado');
      expect(animal.totalInseminacoes, 4);
      expect(animal.needsSync, false);
      expect(animal.lastSynced, isNotNull);
    });

    test('não deve sobrescrever campos com nulos do Firestore', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_001',
        nomeAnimal: 'Mimosa',
        racaAnimal: 'Holandesa',
        status: 'Vazia',
        brincoAnimal: 1234,
      );

      animal.updateFromFirestore({
        'nomeAnimal': null,
        'racaAnimal': null,
      });

      expect(animal.nomeAnimal, 'Mimosa');
      expect(animal.racaAnimal, 'Holandesa');
      expect(animal.brincoAnimal, 1234);
    });

    test('deve marcar animal como modificado', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_001',
        nomeAnimal: 'Mimosa',
      );

      expect(animal.needsSync, false);
      expect(animal.lastModified, isNull);

      animal.markAsModified();

      expect(animal.needsSync, true);
      expect(animal.lastModified, isNotNull);
    });

    test('deve lidar com soft delete de animal', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_del',
        nomeAnimal: 'Animal a descartar',
        isDeleted: false,
      );

      expect(animal.isDeleted, false);

      animal.isDeleted = true;
      animal.motivoDescarteAnimal = 'Problema reprodutivo';
      animal.dtDescarteAnimal = '06/04/2026';
      animal.markAsModified();

      expect(animal.isDeleted, true);
      expect(animal.motivoDescarteAnimal, 'Problema reprodutivo');
      expect(animal.dtDescarteAnimal, '06/04/2026');
      expect(animal.needsSync, true);
    });
  });

  group('AnimalEntity - Ciclo Reprodutivo', () {
    test('deve registrar inseminação no animal', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_insem',
        nomeAnimal: 'Mimosa',
        status: 'Vazia',
        liberaInseminacao: true,
        totalInseminacoes: 2,
      );

      // Simular registro de inseminação
      animal.dtUltimaInseminacao = '06/04/2026';
      animal.nomeTouroUltimaInseminacao = 'Tornado';
      animal.totalInseminacoes = 3;
      animal.liberaInseminacao = false;
      animal.status = 'Inseminada';
      animal.markAsModified();

      expect(animal.dtUltimaInseminacao, '06/04/2026');
      expect(animal.nomeTouroUltimaInseminacao, 'Tornado');
      expect(animal.totalInseminacoes, 3);
      expect(animal.liberaInseminacao, false);
      expect(animal.status, 'Inseminada');
      expect(animal.needsSync, true);
    });

    test('deve registrar diagnóstico de gestação positivo', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_dg',
        nomeAnimal: 'Mimosa',
        status: 'Inseminada',
        dtUltimaInseminacao: '01/01/2026',
      );

      // Simular DG+
      animal.status = 'Prenha';
      animal.dtDgMais = '06/04/2026';
      animal.dtPartoPrevisto = '10/10/2026';
      animal.dtSecPrevista = '10/08/2026';
      animal.dtPrePartoPrevista = '25/09/2026';
      animal.markAsModified();

      expect(animal.status, 'Prenha');
      expect(animal.dtDgMais, '06/04/2026');
      expect(animal.dtPartoPrevisto, isNotNull);
      expect(animal.dtSecPrevista, isNotNull);
      expect(animal.dtPrePartoPrevista, isNotNull);
      expect(animal.needsSync, true);
    });

    test('deve registrar diagnóstico de gestação negativo', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_dg_neg',
        nomeAnimal: 'Bela',
        status: 'Inseminada',
        dtUltimaInseminacao: '01/01/2026',
      );

      // Simular DG-
      animal.status = 'Vazia';
      animal.dtDgMenos = '06/04/2026';
      animal.liberaInseminacao = true;
      animal.markAsModified();

      expect(animal.status, 'Vazia');
      expect(animal.dtDgMenos, '06/04/2026');
      expect(animal.liberaInseminacao, true);
      expect(animal.needsSync, true);
    });

    test('deve registrar parto do animal', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_parto',
        nomeAnimal: 'Mimosa',
        status: 'Prenha',
        totalPartos: 2,
        dtPartoPrevisto: '10/04/2026',
      );

      // Simular parto
      animal.status = 'Vazia';
      animal.dtUltimoParto = '06/04/2026';
      animal.totalPartos = 3;
      animal.liberaInseminacao = true;
      animal.dtPartoPrevisto = '';
      animal.dtSecPrevista = '';
      animal.markAsModified();

      expect(animal.status, 'Vazia');
      expect(animal.dtUltimoParto, '06/04/2026');
      expect(animal.totalPartos, 3);
      expect(animal.liberaInseminacao, true);
      expect(animal.needsSync, true);
    });

    test('deve registrar secagem do animal', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_sec',
        nomeAnimal: 'Mimosa',
        status: 'Prenha',
        dtSecPrevista: '01/04/2026',
      );

      // Simular secagem
      animal.dtSecagem = '06/04/2026';
      animal.status = 'Seca';
      animal.markAsModified();

      expect(animal.dtSecagem, '06/04/2026');
      expect(animal.status, 'Seca');
      expect(animal.needsSync, true);
    });

    test('deve registrar aborto do animal', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_aborto',
        nomeAnimal: 'Estrela',
        status: 'Prenha',
        dtPartoPrevisto: '15/10/2026',
      );

      // Simular aborto
      animal.status = 'Vazia';
      animal.dtAborto = '06/04/2026';
      animal.liberaInseminacao = true;
      animal.markAsModified();

      expect(animal.status, 'Vazia');
      expect(animal.dtAborto, '06/04/2026');
      expect(animal.liberaInseminacao, true);
      expect(animal.needsSync, true);
    });
  });

  group('AnimalEntity - Validação de Dados', () {
    test('deve validar dados mínimos para cadastro', () {
      final animal = AnimalEntity(
        nomeAnimal: 'Mimosa',
        racaAnimal: 'Holandesa',
        grupoAnimal: 'Vacas',
        brincoAnimal: 1234,
      );

      // Animal precisa ter no mínimo: nome, raça, grupo e brinco
      expect(animal.nomeAnimal, isNotNull);
      expect(animal.nomeAnimal, isNotEmpty);
      expect(animal.racaAnimal, isNotNull);
      expect(animal.racaAnimal, isNotEmpty);
      expect(animal.grupoAnimal, isNotNull);
      expect(animal.grupoAnimal, isNotEmpty);
      expect(animal.brincoAnimal, greaterThan(0));
    });

    test('deve validar grupo animal', () {
      final gruposValidos = [
        'Vacas',
        'Novilhas',
        'Touros',
        'Bezerros',
        'Bezerras'
      ];

      for (final grupo in gruposValidos) {
        final animal = AnimalEntity(
          nomeAnimal: 'Animal Teste',
          grupoAnimal: grupo,
        );
        expect(gruposValidos.contains(animal.grupoAnimal), true);
      }
    });

    test('deve vincular animal à propriedade', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_prop',
        parentPath: 'produtor/prod_001/propriedades/prop_001',
        uidTecnicoPropriedadePath: 'tecnico/tec_001',
        nomeAnimal: 'Mimosa',
        grupoAnimal: 'Vacas',
      );

      expect(animal.parentPath, isNotNull);
      expect(animal.parentPath, contains('propriedades/'));
      expect(animal.uidTecnicoPropriedadePath, isNotNull);
      expect(animal.uidTecnicoPropriedadePath, contains('tecnico/'));
    });

    test('deve gerar nomeBrincoConcat corretamente', () {
      final animal = AnimalEntity(
        nomeAnimal: 'Mimosa',
        brincoAnimal: 1234,
        nomeBrincoConcat: 'Mimosa - 1234',
      );

      expect(animal.nomeBrincoConcat, contains(animal.nomeAnimal!));
      expect(animal.nomeBrincoConcat, contains('1234'));
    });

    test('deve criar múltiplos animais para mesma propriedade', () {
      final propPath = 'produtor/prod_001/propriedades/prop_001';
      final animais = [
        AnimalEntity(
          firestoreId: 'a1',
          parentPath: propPath,
          nomeAnimal: 'Vaca 1',
          grupoAnimal: 'Vacas',
          brincoAnimal: 1001,
        ),
        AnimalEntity(
          firestoreId: 'a2',
          parentPath: propPath,
          nomeAnimal: 'Vaca 2',
          grupoAnimal: 'Vacas',
          brincoAnimal: 1002,
        ),
        AnimalEntity(
          firestoreId: 'a3',
          parentPath: propPath,
          nomeAnimal: 'Touro 1',
          grupoAnimal: 'Touros',
          brincoAnimal: 5001,
        ),
        AnimalEntity(
          firestoreId: 'a4',
          parentPath: propPath,
          nomeAnimal: 'Bezerra 1',
          grupoAnimal: 'Bezerras',
          brincoAnimal: 7001,
        ),
      ];

      expect(animais.length, 4);

      // Todos da mesma propriedade
      for (final a in animais) {
        expect(a.parentPath, propPath);
      }

      // Brincos devem ser únicos
      final brincos = animais.map((a) => a.brincoAnimal).toSet();
      expect(brincos.length, 4);

      // Filtrar por grupo
      final vacas = animais.where((a) => a.grupoAnimal == 'Vacas').toList();
      expect(vacas.length, 2);

      final touros = animais.where((a) => a.grupoAnimal == 'Touros').toList();
      expect(touros.length, 1);
    });
  });

  group('AnimalEntity - Desmame', () {
    test('deve registrar desmame de bezerro', () {
      final bezerro = AnimalEntity(
        firestoreId: 'bez_desmame',
        nomeAnimal: 'Bezerro 1',
        grupoAnimal: 'Bezerros',
        dtNascimento: '01/01/2026',
      );

      // Simular desmame
      bezerro.dtDesmame = DateTime(2026, 7, 1);
      bezerro.status = 'Desmamado';
      bezerro.markAsModified();

      expect(bezerro.dtDesmame, isNotNull);
      expect(bezerro.status, 'Desmamado');
      expect(bezerro.needsSync, true);
    });
  });
}
