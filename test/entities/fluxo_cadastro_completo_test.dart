import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/person_entity.dart';
import 'package:tecmuu/data/objectbox/entities/tecnico_entity.dart';
import 'package:tecmuu/data/objectbox/entities/produtor_entity.dart';
import 'package:tecmuu/data/objectbox/entities/propriedade_entity.dart';
import 'package:tecmuu/data/objectbox/entities/animal_entity.dart';

/// Testes de integração simulando fluxos completos de cadastro
/// sem dependência de Firebase/ObjectBox Store
void main() {
  group(
      'Fluxo Completo: Cadastro de Técnico → Produtor → Propriedade → Animais',
      () {
    late PersonEntity personTecnico;
    late TecnicoEntity tecnico;
    late PersonEntity personProdutor;
    late ProdutorEntity produtor;
    late PropriedadeEntity propriedade;
    late List<AnimalEntity> animais;

    setUp(() {
      // 1. Cadastro do Person (técnico)
      personTecnico = PersonEntity(
        firestoreId: 'person_tec_001',
        displayName: 'Dr. Carlos Veterinário',
        email: 'carlos.vet@email.com',
        cpf: '111.222.333-44',
        phoneNumber: '(11) 91234-5678',
        cidade: 'Campinas',
        endereco: 'Av. Brasil, 500',
        bairro: 'Centro',
        tipo: 'tecnico',
        uid: 'firebase_uid_tec001',
        createdTime: DateTime(2026, 1, 1),
      );

      // 2. Cadastro do Técnico
      tecnico = TecnicoEntity(
        firestoreId: 'tec_001',
        uidPerson: personTecnico.uid,
        liberado: true,
        limiteProdutoresContratado: 50,
        quantidadeProdutoresCadastrados: 0,
        restanteLimiteProdutores: 50,
        limiteAnimaisContratado: 500,
        quantidadeAnimaisCadastrados: 0,
        restanteLimiteAnimais: 500,
      );

      // 3. Cadastro do Person (produtor)
      personProdutor = PersonEntity(
        firestoreId: 'person_prod_001',
        displayName: 'José Fazendeiro',
        email: 'jose@fazenda.com',
        cpf: '555.666.777-88',
        phoneNumber: '(19) 99876-5432',
        cidade: 'Ribeirão Preto',
        endereco: 'Fazenda Sol Nascente',
        tipo: 'produtor',
        uid: 'firebase_uid_prod001',
        createdTime: DateTime(2026, 2, 1),
      );

      // 4. Cadastro do Produtor
      produtor = ProdutorEntity(
        firestoreId: 'prod_001',
        liberado: true,
        uidTecnicoPath: 'tecnico/${tecnico.firestoreId}',
        uidPersonPath: 'person/${personProdutor.firestoreId}',
      );

      // 5. Cadastro da Propriedade
      propriedade = PropriedadeEntity(
        firestoreId: 'prop_001',
        parentPath: 'produtor/${produtor.firestoreId}',
        uidPersonProdutorPath: 'person/${personProdutor.firestoreId}',
        displayName: 'Fazenda Sol Nascente',
        email: personProdutor.email,
        cpf: personProdutor.cpf,
        endereco: 'Estrada Rural KM 15',
        cidade: 'Ribeirão Preto',
        phoneNumber: personProdutor.phoneNumber,
        diasParaDg: '30',
      );

      // 6. Cadastro de Animais
      final propPath =
          'produtor/${produtor.firestoreId}/propriedades/${propriedade.firestoreId}';
      animais = [
        AnimalEntity(
          firestoreId: 'animal_001',
          parentPath: propPath,
          uidTecnicoPropriedadePath: 'tecnico/${tecnico.firestoreId}',
          nomeAnimal: 'Mimosa',
          racaAnimal: 'Holandesa',
          pesoAnimal: '550',
          dtNascimento: '10/03/2020',
          status: 'Vazia',
          grupoAnimal: 'Vacas',
          brincoAnimal: 1001,
          brincoAnimalOrder: 1001,
          idGrupoAnimal: 1,
          idStatusAnimal: 1,
          nomeBrincoConcat: 'Mimosa - 1001',
          liberaInseminacao: true,
        ),
        AnimalEntity(
          firestoreId: 'animal_002',
          parentPath: propPath,
          uidTecnicoPropriedadePath: 'tecnico/${tecnico.firestoreId}',
          nomeAnimal: 'Estrela',
          racaAnimal: 'Jersey',
          pesoAnimal: '480',
          dtNascimento: '22/07/2021',
          status: 'Prenha',
          grupoAnimal: 'Vacas',
          brincoAnimal: 1002,
          brincoAnimalOrder: 1002,
          idGrupoAnimal: 1,
          idStatusAnimal: 2,
          nomeBrincoConcat: 'Estrela - 1002',
          liberaInseminacao: false,
        ),
        AnimalEntity(
          firestoreId: 'animal_003',
          parentPath: propPath,
          uidTecnicoPropriedadePath: 'tecnico/${tecnico.firestoreId}',
          nomeAnimal: 'Tornado',
          racaAnimal: 'Nelore',
          pesoAnimal: '800',
          dtNascimento: '15/01/2019',
          status: 'Ativo',
          grupoAnimal: 'Touros',
          brincoAnimal: 5001,
          brincoAnimalOrder: 5001,
          idGrupoAnimal: 4,
          nomeBrincoConcat: 'Tornado - 5001',
        ),
        AnimalEntity(
          firestoreId: 'animal_004',
          parentPath: propPath,
          uidTecnicoPropriedadePath: 'tecnico/${tecnico.firestoreId}',
          nomeAnimal: 'Belinha',
          racaAnimal: 'Girolando',
          dtNascimento: '01/02/2026',
          vaca: 'Estrela',
          touro: 'Tornado',
          status: 'Recria',
          grupoAnimal: 'Bezerras',
          brincoAnimal: 7001,
          brincoAnimalOrder: 7001,
          idGrupoAnimal: 6,
          nomeBrincoConcat: 'Belinha - 7001',
        ),
      ];
    });

    test('Passo 1: Person do técnico é criado com todos os campos', () {
      expect(personTecnico.firestoreId, 'person_tec_001');
      expect(personTecnico.displayName, 'Dr. Carlos Veterinário');
      expect(personTecnico.email, 'carlos.vet@email.com');
      expect(personTecnico.tipo, 'tecnico');
      expect(personTecnico.uid, isNotNull);
    });

    test('Passo 2: Técnico é vinculado ao Person', () {
      expect(tecnico.uidPerson, personTecnico.uid);
      expect(tecnico.liberado, true);
      expect(tecnico.limiteProdutoresContratado, greaterThan(0));
      expect(tecnico.limiteAnimaisContratado, greaterThan(0));
    });

    test('Passo 3: Person do produtor é criado', () {
      expect(personProdutor.tipo, 'produtor');
      expect(personProdutor.displayName, 'José Fazendeiro');
      expect(personProdutor.uid, isNotNull);
    });

    test('Passo 4: Produtor é vinculado ao técnico e ao person', () {
      expect(produtor.uidTecnicoPath, contains(tecnico.firestoreId!));
      expect(produtor.uidPersonPath, contains(personProdutor.firestoreId!));
      expect(produtor.liberado, true);
    });

    test('Passo 5: Propriedade é criada com dados do produtor', () {
      expect(propriedade.parentPath, contains(produtor.firestoreId!));
      expect(propriedade.uidPersonProdutorPath,
          contains(personProdutor.firestoreId!));
      expect(propriedade.displayName, 'Fazenda Sol Nascente');
      expect(propriedade.email, personProdutor.email);
      expect(propriedade.cpf, personProdutor.cpf);
      expect(propriedade.diasParaDg, isNotNull);
    });

    test('Passo 6: Animais são criados e vinculados à propriedade', () {
      expect(animais.length, 4);

      for (final animal in animais) {
        expect(animal.parentPath, contains(propriedade.firestoreId!));
        expect(
            animal.uidTecnicoPropriedadePath, contains(tecnico.firestoreId!));
        expect(animal.nomeAnimal, isNotNull);
        expect(animal.nomeAnimal, isNotEmpty);
      }
    });

    test('Passo 7: Atualizar limite de produtores do técnico', () {
      // Após cadastrar 1 produtor
      tecnico.quantidadeProdutoresCadastrados = 1;
      tecnico.restanteLimiteProdutores = tecnico.limiteProdutoresContratado - 1;
      tecnico.markAsModified();

      expect(tecnico.quantidadeProdutoresCadastrados, 1);
      expect(tecnico.restanteLimiteProdutores, 49);
      expect(tecnico.needsSync, true);
    });

    test('Passo 8: Atualizar limite de animais do técnico', () {
      // Após cadastrar 4 animais
      tecnico.quantidadeAnimaisCadastrados = animais.length;
      tecnico.restanteLimiteAnimais =
          tecnico.limiteAnimaisContratado - animais.length;
      tecnico.markAsModified();

      expect(tecnico.quantidadeAnimaisCadastrados, 4);
      expect(tecnico.restanteLimiteAnimais, 496);
    });

    test('deve filtrar animais por grupo', () {
      final vacas = animais.where((a) => a.grupoAnimal == 'Vacas').toList();
      final touros = animais.where((a) => a.grupoAnimal == 'Touros').toList();
      final bezerras =
          animais.where((a) => a.grupoAnimal == 'Bezerras').toList();

      expect(vacas.length, 2);
      expect(touros.length, 1);
      expect(bezerras.length, 1);
    });

    test('deve filtrar animais que podem ser inseminados', () {
      final inseminaveis = animais.where((a) => a.liberaInseminacao).toList();

      expect(inseminaveis.length, 1);
      expect(inseminaveis.first.nomeAnimal, 'Mimosa');
    });

    test('brincos devem ser únicos na propriedade', () {
      final brincos = animais.map((a) => a.brincoAnimal).toList();
      final brincosUnicos = brincos.toSet();

      expect(brincosUnicos.length, brincos.length,
          reason: 'Todos os brincos devem ser únicos dentro da propriedade');
    });

    test('todos os dados devem ser convertíveis para Firestore', () {
      // Person técnico
      final personTecData = personTecnico.toFirestore();
      expect(personTecData, isNotNull);
      expect(personTecData['display_name'], isNotNull);

      // Técnico
      final tecData = tecnico.toFirestore();
      expect(tecData, isNotNull);
      expect(tecData['uidPerson'], isNotNull);

      // Person produtor
      final personProdData = personProdutor.toFirestore();
      expect(personProdData, isNotNull);
      expect(personProdData['display_name'], isNotNull);

      // Produtor
      final prodData = produtor.toFirestore();
      expect(prodData, isNotNull);

      // Propriedade
      final propData = propriedade.toFirestore();
      expect(propData, isNotNull);
      expect(propData['display_name'], isNotNull);

      // Animais
      for (final animal in animais) {
        final animalData = animal.toFirestore();
        expect(animalData, isNotNull);
        expect(animalData['nomeAnimal'], isNotNull);
      }
    });
  });

  group('Fluxo: Cadastro Offline com needsSync', () {
    test('deve criar entidades offline marcadas para sincronização', () {
      // Criar person offline
      final person = PersonEntity(
        displayName: 'Novo Técnico Offline',
        email: 'offline@email.com',
        tipo: 'tecnico',
        uid: 'local_uid_temp',
        needsSync: true,
      );
      person.markAsModified();

      expect(person.needsSync, true);
      expect(person.firestoreId, isNull); // Ainda não tem ID do Firestore
      expect(person.lastModified, isNotNull);

      // Criar propriedade offline
      final prop = PropriedadeEntity(
        displayName: 'Fazenda Offline',
        email: 'offline@fazenda.com',
        cidade: 'Cidade Nova',
        needsSync: true,
      );
      prop.markAsModified();

      expect(prop.needsSync, true);
      expect(prop.firestoreId, isNull);

      // Criar animal offline
      final animal = AnimalEntity(
        nomeAnimal: 'Animal Offline',
        racaAnimal: 'Nelore',
        grupoAnimal: 'Vacas',
        brincoAnimal: 9001,
        needsSync: true,
      );
      animal.markAsModified();

      expect(animal.needsSync, true);
      expect(animal.firestoreId, isNull);
    });

    test('deve simular sincronização atribuindo firestoreId', () {
      final animal = AnimalEntity(
        nomeAnimal: 'Animal Para Sincronizar',
        racaAnimal: 'Holandesa',
        grupoAnimal: 'Vacas',
        brincoAnimal: 9002,
        needsSync: true,
      );
      animal.markAsModified();

      expect(animal.firestoreId, isNull);
      expect(animal.needsSync, true);

      // Simular sincronização bem-sucedida
      animal.firestoreId = 'synced_animal_001';
      animal.lastSynced = DateTime.now();
      animal.needsSync = false;

      expect(animal.firestoreId, 'synced_animal_001');
      expect(animal.needsSync, false);
      expect(animal.lastSynced, isNotNull);
    });

    test('deve manter modificações locais enquanto aguarda sync', () {
      final animal = AnimalEntity(
        firestoreId: 'animal_local_edit',
        nomeAnimal: 'Animal Original',
        status: 'Vazia',
        needsSync: false,
      );

      // Usuário faz edição offline
      animal.nomeAnimal = 'Animal Editado Offline';
      animal.status = 'Inseminada';
      animal.dtUltimaInseminacao = '06/04/2026';
      animal.markAsModified();

      expect(animal.nomeAnimal, 'Animal Editado Offline');
      expect(animal.status, 'Inseminada');
      expect(animal.needsSync, true);
      expect(animal.lastModified, isNotNull);
      expect(
        animal.lastSynced == null ||
            animal.lastModified!.isAfter(animal.lastSynced!),
        true,
        reason:
            'lastModified deve ser depois de lastSynced para indicar mudanças pendentes',
      );
    });
  });

  group('Fluxo: Validação de Limites do Plano', () {
    test('deve impedir cadastro quando limite de produtores atingido', () {
      final tecnico = TecnicoEntity(
        firestoreId: 'tec_limite',
        limiteProdutoresContratado: 5,
        quantidadeProdutoresCadastrados: 5,
        restanteLimiteProdutores: 0,
      );

      final podeCadastrarProdutor = tecnico.restanteLimiteProdutores > 0;
      expect(podeCadastrarProdutor, false);
    });

    test('deve permitir cadastro quando há espaço para produtores', () {
      final tecnico = TecnicoEntity(
        firestoreId: 'tec_ok',
        limiteProdutoresContratado: 50,
        quantidadeProdutoresCadastrados: 10,
        restanteLimiteProdutores: 40,
      );

      final podeCadastrarProdutor = tecnico.restanteLimiteProdutores > 0;
      expect(podeCadastrarProdutor, true);
    });

    test('deve impedir cadastro quando limite de animais atingido', () {
      final tecnico = TecnicoEntity(
        firestoreId: 'tec_limite_anim',
        limiteAnimaisContratado: 100,
        quantidadeAnimaisCadastrados: 100,
        restanteLimiteAnimais: 0,
      );

      final podeCadastrarAnimal = tecnico.restanteLimiteAnimais > 0;
      expect(podeCadastrarAnimal, false);
    });

    test('deve permitir cadastro quando há espaço para animais', () {
      final tecnico = TecnicoEntity(
        firestoreId: 'tec_ok_anim',
        limiteAnimaisContratado: 500,
        quantidadeAnimaisCadastrados: 250,
        restanteLimiteAnimais: 250,
      );

      final podeCadastrarAnimal = tecnico.restanteLimiteAnimais > 0;
      expect(podeCadastrarAnimal, true);
    });

    test('deve verificar se técnico está liberado', () {
      final tecnicoLiberado = TecnicoEntity(
        firestoreId: 'tec_lib',
        liberado: true,
      );

      final tecnicoBloqueado = TecnicoEntity(
        firestoreId: 'tec_bloq',
        liberado: false,
      );

      expect(tecnicoLiberado.liberado, true);
      expect(tecnicoBloqueado.liberado, false);
    });
  });
}
