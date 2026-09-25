import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/features/receituario/application/tem_assinatura.dart';

/// A tela do receituário mostrava a assinatura quando o campo era `!= ''`.
/// Campo NULO passa nesse teste, e o `Image.network('')` que vinha depois
/// lançava `No host specified in URI file:///` ao abrir a tela.
void main() {
  test('nulo não tem assinatura', () => expect(temAssinatura(null), false));
  test('vazio não tem assinatura', () => expect(temAssinatura(''), false));
  test('só espaços não tem assinatura',
      () => expect(temAssinatura('   '), false));
  test('url tem assinatura',
      () => expect(temAssinatura('https://x/a.png'), true));
}
