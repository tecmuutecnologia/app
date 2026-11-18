import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/animais/baixa_animal.dart';

void main() {
  group('podeVender', () {
    bool pode(String? grupo, String? status, String? tipo,
            {bool excluido = false}) =>
        podeVender(
            grupo: grupo, status: status, tipoBaixa: tipo, isDeleted: excluido);

    test('sêmen nunca vende (as duas grafias)', () {
      expect(pode('Sêmens', 'Vazia', null), isFalse);
      expect(pode('Semêns', 'Vazia', null), isFalse);
    });
    test('touro vende', () => expect(pode('Touros', 'Ativo', null), isTrue));
    test('bezerro vende', () => expect(pode('Bezerros', null, null), isTrue));
    test('descartado pode ser vendido',
        () => expect(pode('Vacas', 'Descarte', null), isTrue));
    test('vendido não revende',
        () => expect(pode('Vacas', 'Descarte', 'venda'), isFalse));
    test('excluído não vende',
        () => expect(pode('Vacas', 'Vazia', null, excluido: true), isFalse));
  });

  group('ehVendido / ehDescartadoSemVenda', () {
    test('vendido exige status Descarte', () {
      expect(ehVendido('Descarte', 'venda'), isTrue);
      expect(ehVendido('Vazia', 'venda'), isFalse);
    });
    test('descarte antigo sem tipoBaixa é descartado', () {
      expect(ehDescartadoSemVenda('Descarte', null), isTrue);
      expect(ehDescartadoSemVenda('Descarte', 'descarte'), isTrue);
      expect(ehDescartadoSemVenda('Descarte', 'venda'), isFalse);
      expect(ehDescartadoSemVenda('Vazia', null), isFalse);
    });
  });
}
