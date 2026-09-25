import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/pendencias_locais.dart';

/// O logout apaga o banco local inteiro. Antes de apagar, o app precisa saber
/// quanto ainda não chegou ao servidor para avisar o usuário.
void main() {
  group('contarNaoEnviados', () {
    test('sem fila e sem entidades pendentes é zero', () {
      expect(
        contarNaoEnviados(filaPendente: 0, pendentesPorColecao: [0, 0]),
        0,
      );
    });

    test('soma a fila e as pendências de todas as coleções', () {
      expect(
        contarNaoEnviados(filaPendente: 2, pendentesPorColecao: [1, 0, 3]),
        6,
      );
    });

    test('só a fila já conta', () {
      expect(
        contarNaoEnviados(filaPendente: 1, pendentesPorColecao: const []),
        1,
      );
    });
  });
}
