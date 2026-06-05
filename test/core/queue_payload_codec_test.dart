import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/queue_payload_codec.dart';

/// Garante que a fila de pendências offline serializa/desserializa payloads com
/// datas — o bug que quebrava o salvamento offline (JsonUnsupportedObjectError
/// em DateTime/Timestamp).
void main() {
  group('QueuePayloadCodec', () {
    test('round-trip de DateTime', () {
      final dt = DateTime(2026, 6, 4, 10, 30, 15);
      final json = QueuePayloadCodec.encode({'dataDaAcao': dt, 'nome': 'Mimosa'});
      final out = QueuePayloadCodec.decode(json);

      expect(out['nome'], 'Mimosa');
      expect(out['dataDaAcao'], isA<DateTime>());
      expect(out['dataDaAcao'], dt);
    });

    test('Timestamp é reconstruído como DateTime equivalente', () {
      final dt = DateTime(2026, 1, 15, 8, 0, 0);
      final json = QueuePayloadCodec.encode({'last_modified': Timestamp.fromDate(dt)});
      final out = QueuePayloadCodec.decode(json);

      expect(out['last_modified'], isA<DateTime>());
      expect(out['last_modified'], dt);
    });

    test('preserva tipos comuns (string, int, double, bool, null)', () {
      final data = <String, dynamic>{
        's': 'x',
        'i': 7,
        'd': 1.5,
        'b': true,
        'n': null,
      };
      final out = QueuePayloadCodec.decode(QueuePayloadCodec.encode(data));
      expect(out, data);
    });

    test('lida com datas aninhadas em mapas e listas', () {
      final dt = DateTime(2026, 3, 1);
      final json = QueuePayloadCodec.encode({
        'nested': {'quando': dt},
        'lista': [
          {'q': dt}
        ],
      });
      final out = QueuePayloadCodec.decode(json);

      expect((out['nested'] as Map)['quando'], dt);
      expect(((out['lista'] as List).first as Map)['q'], dt);
    });
  });
}
