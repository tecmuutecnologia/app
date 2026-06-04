import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/acao_entity.dart';

/// Fake mínimo de Timestamp do Firestore: expõe apenas `toDate()`, que é o
/// único método usado por `AcaoEntity.fromFirestore`. Evita dependência de
/// `cloud_firestore` nos testes unitários.
class _FakeTimestamp {
  _FakeTimestamp(this._date);
  final DateTime _date;
  DateTime toDate() => _date;
}

/// Fake mínimo de DocumentReference: expõe apenas `path`.
class _FakeRef {
  _FakeRef(this.path);
  final String path;
}

/// Testes de caracterização da `AcaoEntity`.
///
/// Objetivo (Fase 0 da refatoração): fixar o comportamento ATUAL do mapeamento
/// Firestore <-> ObjectBox e das flags de sincronização ANTES de consolidar a
/// camada de sync na Fase 1. Se a refatoração alterar este contrato de forma
/// não intencional, estes testes quebram.
void main() {
  group('AcaoEntity - Criação e valores padrão', () {
    test('deve criar AcaoEntity com flags de sync desligadas', () {
      final acao = AcaoEntity();

      expect(acao.id, 0);
      expect(acao.firestoreId, isNull);
      expect(acao.acao, isNull);
      expect(acao.needsSync, false);
      expect(acao.isDeleted, false);
    });
  });

  group('AcaoEntity - Conversão Firestore', () {
    test('fromFirestore mapeia campos, paths e converte data', () {
      final dataAcao = DateTime(2026, 5, 20, 10, 30);
      final firestoreData = <String, dynamic>{
        'uidAnimalAnimaisProdutores': _FakeRef('animais/animal123'),
        'nomeAnimal': 'Mimosa',
        'acao': 'Inseminação',
        'obsVisita': 'Cio observado',
        'touroInseminacao': 'Touro X',
        'dataVisita': '20/05/2026',
        'uidPropriedade': _FakeRef('propriedades/prop1'),
        'dataDaAcao': _FakeTimestamp(dataAcao),
      };

      final acao = AcaoEntity.fromFirestore(
        firestoreData,
        'acao789',
        'animais/animal123/acoes',
      );

      expect(acao.firestoreId, 'acao789');
      expect(acao.parentPath, 'animais/animal123/acoes');
      expect(acao.uidAnimalAnimaisProdutoresPath, 'animais/animal123');
      expect(acao.uidPropriedadePath, 'propriedades/prop1');
      expect(acao.nomeAnimal, 'Mimosa');
      expect(acao.acao, 'Inseminação');
      expect(acao.touroInseminacao, 'Touro X');
      expect(acao.dataDaAcao, dataAcao);
      // Vindo do Firestore, o registro nasce já sincronizado.
      expect(acao.needsSync, false);
      expect(acao.isDeleted, false);
    });

    test('fromFirestore tolera dataDaAcao e refs ausentes', () {
      final acao = AcaoEntity.fromFirestore(
        <String, dynamic>{'acao': 'Parto'},
        'acaoX',
        'animais/a/acoes',
      );

      expect(acao.acao, 'Parto');
      expect(acao.dataDaAcao, isNull);
      expect(acao.uidAnimalAnimaisProdutoresPath, isNull);
      expect(acao.uidPropriedadePath, isNull);
    });

    test('toFirestore expõe os campos de domínio (sem metadados de sync)', () {
      final dataAcao = DateTime(2026, 1, 15);
      final acao = AcaoEntity(
        firestoreId: 'acaoY',
        acao: 'Secagem',
        nomeAnimal: 'Estrela',
        dataDaAcao: dataAcao,
        needsSync: true,
      );

      final map = acao.toFirestore();

      expect(map['acao'], 'Secagem');
      expect(map['nomeAnimal'], 'Estrela');
      expect(map['dataDaAcao'], dataAcao);
      // Metadados de sync NÃO devem ir para o Firestore.
      expect(map.containsKey('needsSync'), false);
      expect(map.containsKey('isDeleted'), false);
      expect(map.containsKey('firestoreId'), false);
    });
  });

  group('AcaoEntity - Sincronização', () {
    test('markAsModified liga needsSync e atualiza lastModified', () {
      final acao = AcaoEntity(acao: 'DG+');
      expect(acao.needsSync, false);

      acao.markAsModified();

      expect(acao.needsSync, true);
      expect(acao.lastModified, isNotNull);
    });

    test('soft delete é representado por isDeleted = true', () {
      final acao = AcaoEntity(acao: 'Aborto', firestoreId: 'acaoZ');

      acao.isDeleted = true;
      acao.markAsModified();

      expect(acao.isDeleted, true);
      expect(acao.needsSync, true);
      // O registro continua existindo localmente (soft delete).
      expect(acao.firestoreId, 'acaoZ');
    });
  });
}
