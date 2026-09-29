import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Campo de texto de entidade do ObjectBox é `String?`: comparar com `''` é
/// bug, porque `null != ''` é TRUE e a condição inverte de sentido.
///
/// Foi o que fez a tela do receituário nunca pedir a assinatura do produtor e
/// liberar o "Gerar PDF" como se o documento já estivesse assinado. Quem decide
/// é `preenchido()`.
void main() {
  const tela =
      'lib/features/receituario/presentation/pages/resumo_visita_atual_page.dart';
  const campos = [
    'assinaturaProdutor',
    'assinaturaTecnico',
    'dtAssinaturaFormatado',
    'obsGeralVisita',
  ];

  test('a tela do receituário não compara esses campos com string vazia', () {
    // O formatador quebra linha no meio das condições, então a busca é sobre o
    // arquivo com os espaços colapsados.
    final fonte = File(tela).readAsStringSync().replaceAll(RegExp(r'\s+'), ' ');

    final reincidencias = [
      for (final campo in campos)
        for (final op in ['==', '!='])
          if (fonte.contains("$campo $op ''")) '$campo $op \'\'',
    ];

    expect(reincidencias, isEmpty);
  });
}
