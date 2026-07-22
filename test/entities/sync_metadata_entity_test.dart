import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/sync_metadata_entity.dart';

/// Testes de caracterização de `SyncMetadataEntity`.
///
/// (A `PendingOperationEntity`, antes neste mesmo arquivo, foi movida para
/// `pending_operation_entity.dart` na Fase 1.5; seus testes estão em
/// `pending_operation_entity_test.dart`.)
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
}
