import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/index.dart';
import 'package:tecmuu/backend/objectbox/repositories/base_sync_repository.dart';

/// Testa o predicado puro de purga de soft-deletes (Fase 1.5), sem depender do
/// ObjectBox em runtime.
void main() {
  group('BaseSyncRepository.isPurgeable', () {
    test('soft-delete já sincronizado é purgável', () {
      final e = AcaoEntity(isDeleted: true, needsSync: false);
      expect(BaseSyncRepository.isPurgeable(e), true);
    });

    test('soft-delete ainda pendente NÃO é purgável (não perder exclusão)', () {
      final e = AcaoEntity(isDeleted: true, needsSync: true);
      expect(BaseSyncRepository.isPurgeable(e), false);
    });

    test('registro ativo NÃO é purgável', () {
      final e = AcaoEntity(isDeleted: false, needsSync: false);
      expect(BaseSyncRepository.isPurgeable(e), false);
    });

    test('registro ativo com pendência NÃO é purgável', () {
      final e = AcaoEntity(isDeleted: false, needsSync: true);
      expect(BaseSyncRepository.isPurgeable(e), false);
    });
  });
}
