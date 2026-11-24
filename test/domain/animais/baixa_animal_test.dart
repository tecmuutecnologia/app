import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
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

  group('parseValorReais', () {
    test('aceita formatos brasileiros', () {
      expect(parseValorReais('1.234,56'), 1234.56);
      expect(parseValorReais('1234,5'), 1234.5);
      expect(parseValorReais('R\$ 10,00'), 10.0);
      expect(parseValorReais('1500'), 1500.0);
    });
    test('ponto como decimal (teclado em inglês) não multiplica por 100', () {
      expect(parseValorReais('1500.50'), 1500.5);
      expect(parseValorReais('10.5'), 10.5);
    });
    test('ponto como milhar no padrão brasileiro', () {
      expect(parseValorReais('1.500'), 1500.0);
      expect(parseValorReais('12.345.678,90'), 12345678.9);
    });
    test('agrupamento inválido é rejeitado', () {
      expect(parseValorReais('1.2.3'), isNull);
      expect(parseValorReais('1,2,3'), isNull);
      expect(parseValorReais('15.00.0'), isNull);
    });
    test('rejeita vazio, zero, negativo e lixo', () {
      expect(parseValorReais(''), isNull);
      expect(parseValorReais('0'), isNull);
      expect(parseValorReais('0,00'), isNull);
      expect(parseValorReais('-5'), isNull);
      expect(parseValorReais('abc'), isNull);
    });
  });

  group('validarDataVenda', () {
    final hoje = DateTime(2026, 11, 18);
    test('hoje é válida', () => expect(validarDataVenda('18/11/2026', hoje: hoje), isNull));
    test('data futura rejeitada', () => expect(validarDataVenda('19/11/2026', hoje: hoje), isNotNull));
    test('data inválida rejeitada', () => expect(validarDataVenda('31/02/2026', hoje: hoje), isNotNull));
    test('vazia rejeitada', () => expect(validarDataVenda('', hoje: hoje), isNotNull));
  });

  group('dadosVenda', () {
    test('vender ativo guarda status anterior', () {
      final m = dadosVenda(
          animal: AnimalEntity(status: 'Prenha', idStatusAnimal: 5),
          dtVenda: '18/11/2026',
          valor: 10,
          idVenda: 'v1');
      expect(m['status'], 'Descarte');
      expect(m['tipoBaixa'], 'venda');
      expect(m['motivoDescarteAnimal'], 'Venda');
      expect(m['dtDescarteAnimal'], '18/11/2026');
      expect(m['dtVendaAnimal'], '18/11/2026');
      expect(m['valorVendaAnimal'], 10);
      expect(m['idVendaAtual'], 'v1');
      expect(m['statusAnterior'], 'Prenha');
      expect(m['idStatusAnteriorAnimal'], 5);
      expect(m['motivoDescarteAnterior'], isNull);
      expect(m.keys, containsAll(kCamposBaixa));
    });

    test('vender descartado guarda o descarte anterior', () {
      final m = dadosVenda(
          animal: AnimalEntity(
              status: 'Descarte',
              tipoBaixa: 'descarte',
              motivoDescarteAnimal: 'Idade',
              dtDescarteAnimal: '01/11/2026',
              statusAnterior: 'Vazia',
              idStatusAnteriorAnimal: 2),
          dtVenda: '18/11/2026',
          valor: 10,
          idVenda: 'v1');
      // O status de ANTES do descarte é preservado: desfazer a venda e depois
      // o descarte ainda leva a vaca de volta a 'Vazia'.
      expect(m['statusAnterior'], 'Vazia');
      expect(m['idStatusAnteriorAnimal'], 2);
      expect(m['motivoDescarteAnterior'], 'Idade');
      expect(m['dtDescarteAnterior'], '01/11/2026');
    });

    test('descarte antigo sem motivo/data ainda é reconhecido como descartado', () {
      final animal = AnimalEntity(status: 'Descarte');
      final m = dadosVenda(
          animal: animal, dtVenda: '18/11/2026', valor: 10, idVenda: 'v1');
      animal
        ..tipoBaixa = m['tipoBaixa']
        ..motivoDescarteAnterior = m['motivoDescarteAnterior']
        ..dtDescarteAnterior = m['dtDescarteAnterior'];
      expect(vendaVeioDeDescarte(animal), isTrue);
    });
  });

  group('dadosDescarte', () {
    test('marca descarte com status anterior', () {
      final m = dadosDescarte(
          animal: AnimalEntity(status: 'Vazia', idStatusAnimal: 2),
          dt: '18/11/2026',
          motivo: 'Idade');
      expect(m['status'], 'Descarte');
      expect(m['tipoBaixa'], 'descarte');
      expect(m['dtDescarteAnimal'], '18/11/2026');
      expect(m['motivoDescarteAnimal'], 'Idade');
      expect(m['statusAnterior'], 'Vazia');
      expect(m['idStatusAnteriorAnimal'], 2);
    });
  });

  group('desfazer', () {
    test('desfazer venda de ativo volta ao status anterior e limpa a baixa', () {
      final a = AnimalEntity(
          status: 'Descarte',
          tipoBaixa: 'venda',
          statusAnterior: 'Prenha',
          idStatusAnteriorAnimal: 5,
          dtVendaAnimal: '18/11/2026',
          valorVendaAnimal: 10,
          idVendaAtual: 'v1');
      final m = dadosDesfazerVenda(a);
      expect(m['status'], 'Prenha');
      expect(m['idStatusAnimal'], 5);
      for (final k in kCamposBaixa) {
        expect(m.containsKey(k), isTrue, reason: k);
        expect(m[k], isNull, reason: k);
      }
      expect(desfazerVendaMexeEmVaga(a), isTrue);
    });

    test('desfazer venda de descartado volta a descartado com motivo original', () {
      final a = AnimalEntity(
          status: 'Descarte',
          tipoBaixa: 'venda',
          statusAnterior: 'Vazia',
          idStatusAnteriorAnimal: 2,
          motivoDescarteAnterior: 'Idade',
          dtDescarteAnterior: '01/11/2026',
          idVendaAtual: 'v1');
      final m = dadosDesfazerVenda(a);
      expect(m['status'], 'Descarte');
      expect(m['tipoBaixa'], 'descarte');
      expect(m['motivoDescarteAnimal'], 'Idade');
      expect(m['dtDescarteAnimal'], '01/11/2026');
      // continua sabendo para onde voltar se o descarte for desfeito depois
      expect(m['statusAnterior'], 'Vazia');
      expect(m['idStatusAnteriorAnimal'], 2);
      expect(m['idVendaAtual'], isNull);
      expect(m['valorVendaAnimal'], isNull);
      expect(m['motivoDescarteAnterior'], isNull);
      expect(desfazerVendaMexeEmVaga(a), isFalse);
    });

    test('desfazer descarte antigo sem statusAnterior volta Vazia/2', () {
      final m = dadosDesfazerDescarte(AnimalEntity(status: 'Descarte'));
      expect(m['status'], 'Vazia');
      expect(m['idStatusAnimal'], 2);
      for (final k in kCamposBaixa) {
        expect(m[k], isNull, reason: k);
      }
    });

    test('desfazer descarte volta ao status anterior', () {
      final m = dadosDesfazerDescarte(AnimalEntity(
          status: 'Descarte', statusAnterior: 'Prenha', idStatusAnteriorAnimal: 5));
      expect(m['status'], 'Prenha');
      expect(m['idStatusAnimal'], 5);
    });
  });
}
