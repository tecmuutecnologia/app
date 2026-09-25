import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/reparo_visitas.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';

/// Visita criada ONLINE subiu sem `uidPropriedade` (o payload do repositório
/// mandava só os campos escalares). O documento existe, mas nenhum download o
/// encontra, porque a busca filtra por esse campo. O reparo reenvia as visitas
/// locais, que têm o vínculo, com o payload agora completo.
void main() {
  group('jaSubiu', () {
    test('com firestoreId e não excluído', () {
      expect(jaSubiu(RecomendacaoEntity(firestoreId: 'R1')), true);
    });

    test('sem firestoreId o push normal já cobre', () {
      expect(jaSubiu(RecomendacaoEntity()), false);
    });

    test('excluído fica de fora', () {
      expect(jaSubiu(RecomendacaoEntity(firestoreId: 'R1', isDeleted: true)),
          false);
    });
  });

  group('precisaReenviarVinculo', () {
    test('visita sincronizada com propriedade é reenviada', () {
      expect(
        precisaReenviarVinculo(ResumoVisitaEntity(
          firestoreId: 'V1',
          uidPropriedadePath: 'tecnico/T1/propriedades/P1',
        )),
        true,
      );
    });

    test('visita que nunca subiu não precisa: o push normal a cobre', () {
      expect(
        precisaReenviarVinculo(ResumoVisitaEntity(
          uidPropriedadePath: 'tecnico/T1/propriedades/P1',
        )),
        false,
      );
    });

    test('sem propriedade local não há vínculo para reenviar', () {
      expect(precisaReenviarVinculo(ResumoVisitaEntity(firestoreId: 'V1')),
          false);
    });

    test('visita excluída fica de fora', () {
      expect(
        precisaReenviarVinculo(ResumoVisitaEntity(
          firestoreId: 'V1',
          uidPropriedadePath: 'tecnico/T1/propriedades/P1',
          isDeleted: true,
        )),
        false,
      );
    });
  });
}
