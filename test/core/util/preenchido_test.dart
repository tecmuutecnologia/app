import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/util/preenchido.dart';

/// As telas do FlutterFlow comparam campo de texto com `''` para saber se ele
/// tem conteúdo. As entidades do ObjectBox usam `null` no lugar de `''`, e
/// `null != ''` é TRUE: cada uma dessas comparações inverteu de sentido depois
/// da migração. No receituário isso fez a tela nunca pedir a assinatura e
/// liberar o PDF como se o documento já estivesse assinado.
void main() {
  test('nulo não está preenchido', () => expect(preenchido(null), false));
  test('vazio não está preenchido', () => expect(preenchido(''), false));
  test('só espaços não está preenchido',
      () => expect(preenchido('   '), false));
  test('texto está preenchido', () => expect(preenchido('28/09/2026'), true));
}
