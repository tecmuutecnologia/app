import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/backend/objectbox/entities/index.dart';

/// Garante que as entidades migradas para a camada de repositórios cumprem o
/// contrato [SyncableEntity]. Se alguém quebrar o contrato (remover um campo ou
/// mudar a assinatura de `markAsModified`), este teste falha em compilação/exec.
void main() {
  group('SyncableEntity - adesão das entidades', () {
    test('AnimalEntity implementa SyncableEntity', () {
      expect(AnimalEntity(), isA<SyncableEntity>());
    });

    test('AcaoEntity implementa SyncableEntity', () {
      expect(AcaoEntity(), isA<SyncableEntity>());
    });

    test('AcaoDaVisitaEntity implementa SyncableEntity', () {
      expect(AcaoDaVisitaEntity(), isA<SyncableEntity>());
    });

    test('PropriedadeEntity implementa SyncableEntity', () {
      expect(PropriedadeEntity(), isA<SyncableEntity>());
    });

    test('entidades do grupo 2 implementam SyncableEntity', () {
      expect(TratamentoEntity(), isA<SyncableEntity>());
      expect(AcaoSanitarioEntity(), isA<SyncableEntity>());
      expect(FinanceiroEntity(), isA<SyncableEntity>());
      expect(ResumoVisitaEntity(), isA<SyncableEntity>());
      expect(RecomendacaoEntity(), isA<SyncableEntity>());
    });

    test('markAsModified do grupo 2 funciona sem userId (via interface)', () {
      final SyncableEntity entity = TratamentoEntity();
      entity.markAsModified();
      expect(entity.needsSync, true);
      expect(entity.lastModified, isNotNull);
    });

    test('entidades de topo implementam SyncableEntity com parentPath nulo', () {
      for (final SyncableEntity e in [
        PersonEntity(),
        TecnicoEntity(),
        ProdutorEntity(),
      ]) {
        expect(e, isA<SyncableEntity>());
        expect(e.parentPath, isNull); // coleção de topo, sem documento pai
      }
    });

    test('markAsModified liga needsSync via interface', () {
      final SyncableEntity entity = AcaoEntity();
      expect(entity.needsSync, false);

      entity.markAsModified();

      expect(entity.needsSync, true);
      expect(entity.lastModified, isNotNull);
    });
  });
}
