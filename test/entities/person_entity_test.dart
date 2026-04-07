import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/person_entity.dart';

void main() {
  group('PersonEntity - Cadastro de Novo Usuário', () {
    test('deve criar um PersonEntity com valores padrão', () {
      final person = PersonEntity();

      expect(person.id, 0);
      expect(person.firestoreId, isNull);
      expect(person.displayName, isNull);
      expect(person.email, isNull);
      expect(person.cpf, isNull);
      expect(person.phoneNumber, isNull);
      expect(person.needsSync, false);
      expect(person.isDeleted, false);
    });

    test('deve criar um PersonEntity tipo técnico completo', () {
      final person = PersonEntity(
        firestoreId: 'tech_001',
        displayName: 'Dr. João Silva',
        email: 'joao.silva@email.com',
        cpf: '123.456.789-00',
        phoneNumber: '(11) 99999-1234',
        cidade: 'São Paulo',
        endereco: 'Rua das Flores, 123',
        bairro: 'Centro',
        tipo: 'tecnico',
        empresa: 'AgroPecuária LTDA',
        uid: 'firebase_uid_123',
        createdTime: DateTime(2026, 1, 15),
      );

      expect(person.firestoreId, 'tech_001');
      expect(person.displayName, 'Dr. João Silva');
      expect(person.email, 'joao.silva@email.com');
      expect(person.cpf, '123.456.789-00');
      expect(person.phoneNumber, '(11) 99999-1234');
      expect(person.cidade, 'São Paulo');
      expect(person.endereco, 'Rua das Flores, 123');
      expect(person.bairro, 'Centro');
      expect(person.tipo, 'tecnico');
      expect(person.empresa, 'AgroPecuária LTDA');
      expect(person.uid, 'firebase_uid_123');
      expect(person.createdTime, DateTime(2026, 1, 15));
    });

    test('deve criar um PersonEntity tipo produtor completo', () {
      final person = PersonEntity(
        firestoreId: 'prod_001',
        displayName: 'José Produtor',
        email: 'jose@fazenda.com',
        cpf: '987.654.321-00',
        phoneNumber: '(19) 98765-4321',
        cidade: 'Ribeirão Preto',
        endereco: 'Fazenda Boa Vista',
        bairro: 'Rural',
        tipo: 'produtor',
        uid: 'firebase_uid_456',
        dtNascimento: '15/03/1980',
      );

      expect(person.tipo, 'produtor');
      expect(person.displayName, 'José Produtor');
      expect(person.dtNascimento, '15/03/1980');
    });

    test('deve converter PersonEntity para Firestore corretamente', () {
      final person = PersonEntity(
        firestoreId: 'tech_001',
        displayName: 'Dr. João Silva',
        email: 'joao@email.com',
        cpf: '123.456.789-00',
        phoneNumber: '(11) 99999-1234',
        cidade: 'São Paulo',
        endereco: 'Rua das Flores, 123',
        bairro: 'Centro',
        tipo: 'tecnico',
        empresa: 'AgroTech',
        uid: 'uid_123',
        createdTime: DateTime(2026, 1, 15),
      );

      final firestoreData = person.toFirestore();

      expect(firestoreData['display_name'], 'Dr. João Silva');
      expect(firestoreData['email'], 'joao@email.com');
      expect(firestoreData['cpf'], '123.456.789-00');
      expect(firestoreData['phone_number'], '(11) 99999-1234');
      expect(firestoreData['cidade'], 'São Paulo');
      expect(firestoreData['endereco'], 'Rua das Flores, 123');
      expect(firestoreData['bairro'], 'Centro');
      expect(firestoreData['tipo'], 'tecnico');
      expect(firestoreData['empresa'], 'AgroTech');
      expect(firestoreData['uid'], 'uid_123');
      expect(firestoreData['created_time'], DateTime(2026, 1, 15));
    });

    test('deve marcar como modificado corretamente', () {
      final person = PersonEntity(
        displayName: 'Teste',
        email: 'teste@email.com',
      );

      expect(person.needsSync, false);
      expect(person.lastModified, isNull);

      person.markAsModified();

      expect(person.needsSync, true);
      expect(person.lastModified, isNotNull);
    });

    test('deve atualizar campos a partir do Firestore', () {
      final person = PersonEntity(
        firestoreId: 'test_001',
        displayName: 'Nome Antigo',
        email: 'antigo@email.com',
        cidade: 'Cidade Velha',
        needsSync: true,
      );

      person.updateFromFirestore({
        'display_name': 'Nome Atualizado',
        'email': 'novo@email.com',
        'cidade': 'Cidade Nova',
        'phone_number': '(11) 11111-1111',
        'tipo': 'tecnico',
      });

      expect(person.displayName, 'Nome Atualizado');
      expect(person.email, 'novo@email.com');
      expect(person.cidade, 'Cidade Nova');
      expect(person.phoneNumber, '(11) 11111-1111');
      expect(person.tipo, 'tecnico');
      expect(person.needsSync, false);
      expect(person.lastSynced, isNotNull);
    });

    test('não deve sobrescrever campos existentes com nulos', () {
      final person = PersonEntity(
        displayName: 'Nome Original',
        email: 'original@email.com',
        cpf: '111.222.333-44',
      );

      person.updateFromFirestore({
        'display_name': null,
        'email': null,
      });

      // Campos devem manter valores anteriores quando Firestore retorna null
      expect(person.displayName, 'Nome Original');
      expect(person.email, 'original@email.com');
      expect(person.cpf, '111.222.333-44');
    });

    test('deve validar campos obrigatórios de cadastro de técnico', () {
      final tecnico = PersonEntity(
        displayName: 'Dr. Técnico',
        email: 'tecnico@email.com',
        tipo: 'tecnico',
        uid: 'uid_tecnico',
      );

      // Técnico deve ter tipo, nome, email e uid
      expect(tecnico.displayName, isNotNull);
      expect(tecnico.displayName, isNotEmpty);
      expect(tecnico.email, isNotNull);
      expect(tecnico.email, isNotEmpty);
      expect(tecnico.tipo, 'tecnico');
      expect(tecnico.uid, isNotNull);
    });

    test('deve validar campos obrigatórios de cadastro de produtor', () {
      final produtor = PersonEntity(
        displayName: 'Sr. Produtor',
        email: 'produtor@fazenda.com',
        tipo: 'produtor',
        uid: 'uid_produtor',
        cpf: '123.456.789-00',
      );

      expect(produtor.displayName, isNotNull);
      expect(produtor.email, isNotNull);
      expect(produtor.tipo, 'produtor');
      expect(produtor.uid, isNotNull);
      expect(produtor.cpf, isNotNull);
    });

    test('deve lidar com soft delete corretamente', () {
      final person = PersonEntity(
        firestoreId: 'del_001',
        displayName: 'Usuário a Deletar',
        isDeleted: false,
      );

      expect(person.isDeleted, false);

      person.isDeleted = true;
      person.markAsModified();

      expect(person.isDeleted, true);
      expect(person.needsSync, true);
    });
  });

  group('TecnicoEntity - Dados do Técnico', () {
    // Tests for TecnicoEntity are in tecnico_entity_test.dart
  });
}
