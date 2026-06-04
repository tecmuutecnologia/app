import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/pending_operation_entity.dart';

/// Testes da `PendingOperationEntity` (fila de operações pendentes de sync).
///
/// Fixa os defaults (retryCount, priority) e o comportamento de retry, para que
/// não mudem por acidente durante refatorações da camada de sincronização.
void main() {
  group('PendingOperationEntity - fila de operações', () {
    test('defaults: prioridade média (3), sem retries e sem erro', () {
      final op = PendingOperationEntity(
        operationType: 'CREATE',
        collectionName: 'animais',
      );

      expect(op.id, 0);
      expect(op.operationType, 'CREATE');
      expect(op.collectionName, 'animais');
      expect(op.retryCount, 0);
      expect(op.priority, 3);
      expect(op.lastError, isNull);
      expect(op.firestoreId, isNull);
      expect(op.documentPath, isNull);
    });

    test('preserva payload, path e prioridade para retry', () {
      final createdAt = DateTime(2026, 6, 1, 8, 0);
      final op = PendingOperationEntity(
        operationType: 'UPDATE',
        collectionName: 'acoes',
        firestoreId: 'acao123',
        documentPath: 'animais/a1/acoes/acao123',
        dataJson: '{"acao":"DG+"}',
        createdAt: createdAt,
        priority: 1,
      );

      expect(op.operationType, 'UPDATE');
      expect(op.documentPath, 'animais/a1/acoes/acao123');
      expect(op.dataJson, '{"acao":"DG+"}');
      expect(op.createdAt, createdAt);
      expect(op.priority, 1);
    });

    test('contagem de retry e último erro são mutáveis (cenário de falha)', () {
      final op = PendingOperationEntity(
        operationType: 'DELETE',
        collectionName: 'tratamentos',
      );

      // Simula falhas sucessivas de sincronização.
      op.retryCount += 1;
      op.lastError = 'network-request-failed';
      op.retryCount += 1;

      expect(op.retryCount, 2);
      expect(op.lastError, 'network-request-failed');
    });
  });
}
