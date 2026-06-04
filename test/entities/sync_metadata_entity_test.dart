import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/sync_metadata_entity.dart';

/// Testes de caracterização de `SyncMetadataEntity` e `PendingOperationEntity`.
///
/// Objetivo (Fase 0): fixar o contrato ATUAL da fila de operações pendentes e
/// dos metadados de sincronização ANTES da Fase 1, que vai unificar os serviços
/// de sync e mover `PendingOperationEntity` para arquivo próprio. Estes testes
/// garantem que os defaults (retryCount, priority, etc.) não mudem por acidente
/// durante a migração.
void main() {
  group('SyncMetadataEntity - estado de sincronização', () {
    test('defaults: sync inicial não concluído e contadores zerados', () {
      final meta = SyncMetadataEntity(collectionName: 'animais');

      expect(meta.id, 0);
      expect(meta.collectionName, 'animais');
      expect(meta.initialSyncComplete, false);
      expect(meta.recordCount, 0);
      expect(meta.schemaVersion, 1);
      expect(meta.lastFullSync, isNull);
      expect(meta.lastIncrementalSync, isNull);
    });

    test('aceita marcação de sync inicial concluído', () {
      final now = DateTime(2026, 6, 3, 12);
      final meta = SyncMetadataEntity(
        collectionName: 'acoes',
        initialSyncComplete: true,
        lastFullSync: now,
        recordCount: 42,
      );

      expect(meta.initialSyncComplete, true);
      expect(meta.lastFullSync, now);
      expect(meta.recordCount, 42);
    });
  });

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
