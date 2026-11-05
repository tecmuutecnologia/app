import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/animais/importacao/planilha_animais.dart';
import 'package:tecmuu/features/animais/application/ler_xlsx.dart';

void main() {
  test('lê o modelo: 2 linhas e cabeçalho ok', () {
    final l = lerXlsx(
        File('assets/planilhas/modelo_importacao_animais.xlsx').readAsBytesSync());
    expect(l.length, 2);
    expect(erroDeCabecalho(l.first), isNull);
  });

  test('bytes inválidos lançam FormatException', () {
    expect(() => lerXlsx(Uint8List.fromList([1, 2, 3])),
        throwsA(isA<FormatException>()));
  });
}
