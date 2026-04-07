import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/tecnico_entity.dart';
import 'package:tecmuu/backend/objectbox/entities/produtor_entity.dart';
import 'package:tecmuu/backend/objectbox/entities/propriedade_entity.dart';

void main() {
  group('TecnicoEntity - Cadastro de Técnico', () {
    test('deve criar TecnicoEntity com valores padrão', () {
      final tecnico = TecnicoEntity();

      expect(tecnico.id, 0);
      expect(tecnico.firestoreId, isNull);
      expect(tecnico.uidPerson, isNull);
      expect(tecnico.liberado, false);
      expect(tecnico.limiteProdutoresContratado, 0);
      expect(tecnico.quantidadeProdutoresCadastrados, 0);
      expect(tecnico.restanteLimiteProdutores, 0);
      expect(tecnico.limiteAnimaisContratado, 0);
      expect(tecnico.quantidadeAnimaisCadastrados, 0);
      expect(tecnico.restanteLimiteAnimais, 0);
      expect(tecnico.needsSync, false);
      expect(tecnico.isDeleted, false);
    });

    test('deve criar TecnicoEntity com plano completo', () {
      final tecnico = TecnicoEntity(
        firestoreId: 'tec_001',
        uidPerson: 'person_uid_123',
        liberado: true,
        limiteProdutoresContratado: 50,
        quantidadeProdutoresCadastrados: 10,
        restanteLimiteProdutores: 40,
        limiteAnimaisContratado: 500,
        quantidadeAnimaisCadastrados: 100,
        restanteLimiteAnimais: 400,
      );

      expect(tecnico.firestoreId, 'tec_001');
      expect(tecnico.uidPerson, 'person_uid_123');
      expect(tecnico.liberado, true);
      expect(tecnico.limiteProdutoresContratado, 50);
      expect(tecnico.quantidadeProdutoresCadastrados, 10);
      expect(tecnico.restanteLimiteProdutores, 40);
      expect(tecnico.limiteAnimaisContratado, 500);
      expect(tecnico.quantidadeAnimaisCadastrados, 100);
      expect(tecnico.restanteLimiteAnimais, 400);
    });

    test('deve converter TecnicoEntity para Firestore', () {
      final tecnico = TecnicoEntity(
        firestoreId: 'tec_001',
        uidPerson: 'person_uid_123',
        liberado: true,
        limiteProdutoresContratado: 30,
        quantidadeProdutoresCadastrados: 5,
        restanteLimiteProdutores: 25,
        limiteAnimaisContratado: 300,
        quantidadeAnimaisCadastrados: 50,
        restanteLimiteAnimais: 250,
      );

      final data = tecnico.toFirestore();

      expect(data['uidPerson'], 'person_uid_123');
      expect(data['liberado'], true);
      expect(data['limiteProdutoresContratado'], 30);
      expect(data['quantidadeProdutoresCadastrados'], 5);
      expect(data['restanteLimiteProdutores'], 25);
      expect(data['limiteAnimaisContratado'], 300);
      expect(data['quantidadeAnimaisCadastrados'], 50);
      expect(data['restanteLimiteAnimais'], 250);
    });

    test('deve atualizar TecnicoEntity a partir do Firestore', () {
      final tecnico = TecnicoEntity(
        firestoreId: 'tec_001',
        uidPerson: 'person_uid_123',
        liberado: false,
        limiteProdutoresContratado: 10,
        quantidadeProdutoresCadastrados: 5,
        needsSync: true,
      );

      tecnico.updateFromFirestore({
        'liberado': true,
        'limiteProdutoresContratado': 100,
        'quantidadeProdutoresCadastrados': 20,
        'restanteLimiteProdutores': 80,
        'limiteAnimaisContratado': 1000,
      });

      expect(tecnico.liberado, true);
      expect(tecnico.limiteProdutoresContratado, 100);
      expect(tecnico.quantidadeProdutoresCadastrados, 20);
      expect(tecnico.restanteLimiteProdutores, 80);
      expect(tecnico.limiteAnimaisContratado, 1000);
      expect(tecnico.needsSync, false);
      expect(tecnico.lastSynced, isNotNull);
    });

    test('deve verificar limites de produtores do técnico', () {
      final tecnico = TecnicoEntity(
        limiteProdutoresContratado: 10,
        quantidadeProdutoresCadastrados: 10,
        restanteLimiteProdutores: 0,
      );

      // Técnico está no limite de produtores
      expect(tecnico.restanteLimiteProdutores, 0);
      expect(
        tecnico.quantidadeProdutoresCadastrados >=
            tecnico.limiteProdutoresContratado,
        true,
      );
    });

    test('deve verificar limites de animais do técnico', () {
      final tecnico = TecnicoEntity(
        limiteAnimaisContratado: 500,
        quantidadeAnimaisCadastrados: 250,
        restanteLimiteAnimais: 250,
      );

      // Técnico tem espaço para mais animais
      expect(tecnico.restanteLimiteAnimais, greaterThan(0));
      expect(
        tecnico.quantidadeAnimaisCadastrados < tecnico.limiteAnimaisContratado,
        true,
      );
    });

    test('deve marcar TecnicoEntity como modificado', () {
      final tecnico = TecnicoEntity(firestoreId: 'tec_001');

      expect(tecnico.needsSync, false);

      tecnico.markAsModified();

      expect(tecnico.needsSync, true);
      expect(tecnico.lastModified, isNotNull);
    });
  });

  group('ProdutorEntity - Cadastro de Produtor', () {
    test('deve criar ProdutorEntity com valores padrão', () {
      final produtor = ProdutorEntity();

      expect(produtor.id, 0);
      expect(produtor.firestoreId, isNull);
      expect(produtor.liberado, false);
      expect(produtor.uidTecnicoPath, isNull);
      expect(produtor.uidPersonPath, isNull);
      expect(produtor.needsSync, false);
      expect(produtor.isDeleted, false);
    });

    test('deve criar ProdutorEntity completo', () {
      final produtor = ProdutorEntity(
        firestoreId: 'prod_001',
        liberado: true,
        uidTecnicoPath: 'tecnico/tec_001',
        uidPersonPath: 'person/person_001',
      );

      expect(produtor.firestoreId, 'prod_001');
      expect(produtor.liberado, true);
      expect(produtor.uidTecnicoPath, 'tecnico/tec_001');
      expect(produtor.uidPersonPath, 'person/person_001');
    });

    test('deve converter ProdutorEntity para Firestore', () {
      final produtor = ProdutorEntity(
        firestoreId: 'prod_001',
        liberado: true,
        uidTecnicoPath: 'tecnico/tec_001',
        uidPersonPath: 'person/person_001',
      );

      final data = produtor.toFirestore();

      expect(data['liberado'], true);
    });

    test('deve vincular produtor a um técnico', () {
      final produtor = ProdutorEntity(
        firestoreId: 'prod_001',
        uidTecnicoPath: 'tecnico/tec_abc123',
        uidPersonPath: 'person/person_xyz',
        liberado: true,
      );

      expect(produtor.uidTecnicoPath, isNotNull);
      expect(produtor.uidTecnicoPath, contains('tecnico/'));
      expect(produtor.uidPersonPath, isNotNull);
      expect(produtor.uidPersonPath, contains('person/'));
    });

    test('deve marcar ProdutorEntity como modificado', () {
      final produtor = ProdutorEntity(firestoreId: 'prod_001');

      expect(produtor.needsSync, false);

      produtor.markAsModified();

      expect(produtor.needsSync, true);
      expect(produtor.lastModified, isNotNull);
    });

    test('deve criar produtor pendente de liberação', () {
      final produtor = ProdutorEntity(
        firestoreId: 'prod_pendente',
        liberado: false,
        uidTecnicoPath: 'tecnico/tec_001',
        uidPersonPath: 'person/person_pendente',
        needsSync: true,
      );

      expect(produtor.liberado, false);
      expect(produtor.needsSync, true);
    });
  });

  group('PropriedadeEntity - Cadastro de Propriedade', () {
    test('deve criar PropriedadeEntity com valores padrão', () {
      final prop = PropriedadeEntity();

      expect(prop.id, 0);
      expect(prop.firestoreId, isNull);
      expect(prop.parentPath, isNull);
      expect(prop.displayName, isNull);
      expect(prop.email, isNull);
      expect(prop.cpf, isNull);
      expect(prop.endereco, isNull);
      expect(prop.cidade, isNull);
      expect(prop.phoneNumber, isNull);
      expect(prop.diasParaDg, isNull);
      expect(prop.isDeleted, false);
      expect(prop.needsSync, false);
    });

    test('deve criar PropriedadeEntity completa', () {
      final prop = PropriedadeEntity(
        firestoreId: 'prop_001',
        parentPath: 'produtor/prod_001',
        uidPersonProdutorPath: 'person/person_001',
        displayName: 'Fazenda Boa Vista',
        email: 'fazenda@email.com',
        cpf: '12.345.678/0001-00',
        endereco: 'Estrada Rural KM 15',
        cidade: 'Ribeirão Preto',
        phoneNumber: '(16) 99876-5432',
        diasParaDg: '30',
      );

      expect(prop.firestoreId, 'prop_001');
      expect(prop.parentPath, 'produtor/prod_001');
      expect(prop.uidPersonProdutorPath, 'person/person_001');
      expect(prop.displayName, 'Fazenda Boa Vista');
      expect(prop.email, 'fazenda@email.com');
      expect(prop.cpf, '12.345.678/0001-00');
      expect(prop.endereco, 'Estrada Rural KM 15');
      expect(prop.cidade, 'Ribeirão Preto');
      expect(prop.phoneNumber, '(16) 99876-5432');
      expect(prop.diasParaDg, '30');
    });

    test('deve converter PropriedadeEntity para Firestore', () {
      final prop = PropriedadeEntity(
        firestoreId: 'prop_001',
        displayName: 'Fazenda Sol Nascente',
        email: 'sol@fazenda.com',
        cpf: '111.222.333-44',
        endereco: 'Rodovia BR-116 KM 5',
        cidade: 'Uberaba',
        phoneNumber: '(34) 98765-1234',
        diasParaDg: '35',
      );

      final data = prop.toFirestore();

      expect(data['display_name'], 'Fazenda Sol Nascente');
      expect(data['email'], 'sol@fazenda.com');
      expect(data['cpf'], '111.222.333-44');
      expect(data['endereco'], 'Rodovia BR-116 KM 5');
      expect(data['cidade'], 'Uberaba');
      expect(data['phone_number'], '(34) 98765-1234');
      expect(data['diasParaDg'], '35');
      expect(data['isDeleted'], false);
    });

    test('deve associar propriedade ao produtor', () {
      final prop = PropriedadeEntity(
        firestoreId: 'prop_001',
        parentPath: 'produtor/prod_001',
        uidPersonProdutorPath: 'person/person_001',
        displayName: 'Fazenda Teste',
      );

      expect(prop.parentPath, isNotNull);
      expect(prop.parentPath, contains('produtor/'));
      expect(prop.uidPersonProdutorPath, isNotNull);
      expect(prop.uidPersonProdutorPath, contains('person/'));
    });

    test('deve soft delete propriedade', () {
      final prop = PropriedadeEntity(
        firestoreId: 'prop_delete',
        displayName: 'Fazenda a Excluir',
        isDeleted: false,
      );

      expect(prop.isDeleted, false);
      expect(prop.deletedAt, isNull);

      prop.isDeleted = true;
      prop.deletedAt = DateTime.now();
      prop.markAsModified();

      expect(prop.isDeleted, true);
      expect(prop.deletedAt, isNotNull);
      expect(prop.needsSync, true);
    });

    test('deve atualizar propriedade a partir do Firestore', () {
      final prop = PropriedadeEntity(
        firestoreId: 'prop_001',
        displayName: 'Nome Antigo',
        cidade: 'Cidade Antiga',
        needsSync: true,
      );

      prop.updateFromFirestore({
        'display_name': 'Nome Atualizado',
        'cidade': 'Cidade Nova',
        'email': 'novo@email.com',
        'diasParaDg': '45',
      });

      expect(prop.displayName, 'Nome Atualizado');
      expect(prop.cidade, 'Cidade Nova');
      expect(prop.email, 'novo@email.com');
      expect(prop.diasParaDg, '45');
      expect(prop.needsSync, false);
      expect(prop.lastSynced, isNotNull);
    });

    test('não deve sobrescrever campos com valores nulos do Firestore', () {
      final prop = PropriedadeEntity(
        firestoreId: 'prop_001',
        displayName: 'Fazenda Original',
        email: 'original@fazenda.com',
        cidade: 'Cidade Original',
      );

      prop.updateFromFirestore({
        'display_name': null,
        'email': null,
      });

      expect(prop.displayName, 'Fazenda Original');
      expect(prop.email, 'original@fazenda.com');
      expect(prop.cidade, 'Cidade Original');
    });

    test('deve configurar dias para DG na propriedade', () {
      final prop = PropriedadeEntity(
        firestoreId: 'prop_dg',
        displayName: 'Fazenda DG',
        diasParaDg: '30',
      );

      expect(prop.diasParaDg, isNotNull);
      expect(prop.diasParaDg, '30');

      // Atualizar dias para DG
      prop.diasParaDg = '45';
      prop.markAsModified();

      expect(prop.diasParaDg, '45');
      expect(prop.needsSync, true);
    });

    test('deve criar múltiplas propriedades para um produtor', () {
      final props = [
        PropriedadeEntity(
          firestoreId: 'prop_001',
          parentPath: 'produtor/prod_001',
          displayName: 'Fazenda 1',
          cidade: 'Cidade A',
        ),
        PropriedadeEntity(
          firestoreId: 'prop_002',
          parentPath: 'produtor/prod_001',
          displayName: 'Fazenda 2',
          cidade: 'Cidade B',
        ),
        PropriedadeEntity(
          firestoreId: 'prop_003',
          parentPath: 'produtor/prod_001',
          displayName: 'Fazenda 3',
          cidade: 'Cidade C',
        ),
      ];

      // Todas do mesmo produtor
      expect(props.length, 3);
      for (final prop in props) {
        expect(prop.parentPath, 'produtor/prod_001');
      }

      // Cada uma com nome distinto
      final nomes = props.map((p) => p.displayName).toSet();
      expect(nomes.length, 3);
    });
  });
}
