import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/decisao_recalculo.dart';
import 'package:tecmuu/core/sync/queue_payload_codec.dart';

void main() {
  group('QueuePayloadCodec.incrementos', () {
    test('devolve os deltas gravados na fila', () {
      final json = QueuePayloadCodec.encode({
        'quantidadeAnimaisCadastrados': const QueueIncrement(2),
        'restanteLimiteAnimais': const QueueIncrement(-2),
      });

      expect(QueuePayloadCodec.incrementos(json), {
        'quantidadeAnimaisCadastrados': 2,
        'restanteLimiteAnimais': -2,
      });
    });

    test('ignora campos que não são incremento', () {
      final json = QueuePayloadCodec.encode({
        'nome': 'x',
        'restanteLimiteAnimais': const QueueIncrement(1),
      });

      expect(QueuePayloadCodec.incrementos(json), {'restanteLimiteAnimais': 1});
    });
  });

  group('somarDeltasDaFila', () {
    test('sem fila, vale o valor do servidor', () {
      expect(
        somarDeltasDaFila({'restanteLimiteAnimais': 5480}, const []),
        {'restanteLimiteAnimais': 5480},
      );
    });

    test('débitos ainda na fila continuam descontados do servidor', () {
      expect(
        somarDeltasDaFila({
          'restanteLimiteAnimais': 5480,
          'quantidadeAnimaisCadastrados': 2520,
        }, const [
          {'restanteLimiteAnimais': -1, 'quantidadeAnimaisCadastrados': 1},
          {'restanteLimiteAnimais': -2, 'quantidadeAnimaisCadastrados': 2},
        ]),
        {'restanteLimiteAnimais': 5477, 'quantidadeAnimaisCadastrados': 2523},
      );
    });

    test('delta de campo fora da cota é ignorado', () {
      expect(
        somarDeltasDaFila({'restanteLimiteAnimais': 10}, const [
          {'outroCampo': 7},
        ]),
        {'restanteLimiteAnimais': 10},
      );
    });
  });
}
