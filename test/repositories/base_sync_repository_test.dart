import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/data/objectbox/repositories/base_sync_repository.dart';

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

  group('BaseSyncRepository.carimbarLastModified', () {
    test('acrescenta lastModified ao payload', () {
      final payload =
          BaseSyncRepository.carimbarLastModified({'nome': 'Mimosa'});
      expect(payload.containsKey('lastModified'), true);
    });

    test('preserva os campos originais', () {
      final payload = BaseSyncRepository.carimbarLastModified(
          {'nome': 'Mimosa', 'peso': 3});
      expect(payload['nome'], 'Mimosa');
      expect(payload['peso'], 3);
    });

    test('nao muta o mapa recebido', () {
      final original = <String, dynamic>{'nome': 'Mimosa'};
      BaseSyncRepository.carimbarLastModified(original);
      expect(original.containsKey('lastModified'), false);
    });

    test('sobrescreve lastModified preexistente com o carimbo do servidor', () {
      final payload = BaseSyncRepository.carimbarLastModified(
          {'lastModified': 'texto qualquer'});
      expect(payload['lastModified'], isNot('texto qualquer'));
    });
  });
}
