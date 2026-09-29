import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/util/data_flexivel.dart';

/// O mesmo campo de data chega como `Timestamp` (documento do Firestore) ou
/// como `DateTime` (entidade do ObjectBox). O cast fixo para `Timestamp`
/// derrubava a geração do receituário depois da migração para o ObjectBox:
/// "type 'DateTime' is not a subtype of type 'Timestamp?' in type cast".
void main() {
  test('Timestamp vira DateTime no mesmo instante', () {
    final data = DateTime.utc(2026, 9, 28, 8, 49);
    // `toDate()` devolve data LOCAL: o que importa é o instante, não o fuso.
    expect(comoData(Timestamp.fromDate(data))!.isAtSameMomentAs(data), true);
  });

  test('DateTime passa direto', () {
    final data = DateTime(2026, 9, 28);
    expect(comoData(data), data);
  });

  test('nulo devolve nulo', () => expect(comoData(null), isNull));

  test('tipo inesperado devolve nulo em vez de estourar',
      () => expect(comoData('28/09/2026'), isNull));
}
