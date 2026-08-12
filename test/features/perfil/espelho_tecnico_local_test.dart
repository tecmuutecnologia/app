import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/tecnico_entity.dart';
import 'package:tecmuu/features/perfil/application/espelho_tecnico_local.dart';

void main() {
  group('espelhoDoTecnicoRecemCriado', () {
    test('espelha o técnico com o uidPerson que o dashboard consulta', () {
      final espelho = espelhoDoTecnicoRecemCriado(
        firestoreId: 'tec_abc',
        dados: const {'uidPerson': 'uid_auth_123', 'liberado': true},
        jaNoCache: null,
      );

      expect(espelho, isNotNull);
      expect(espelho!.uidPerson, 'uid_auth_123');
      expect(espelho.firestoreId, 'tec_abc');
    });

    test('nao regrava quando o download completo ja trouxe o tecnico', () {
      final espelho = espelhoDoTecnicoRecemCriado(
        firestoreId: 'tec_abc',
        dados: const {'uidPerson': 'uid_auth_123', 'liberado': true},
        jaNoCache: TecnicoEntity(
          firestoreId: 'tec_abc',
          uidPerson: 'uid_auth_123',
        ),
      );

      expect(espelho, isNull);
    });
  });
}
