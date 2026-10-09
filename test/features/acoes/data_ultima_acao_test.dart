import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/domain/animais/data_ultima_acao.dart';

void main() {
  final quando = DateTime(2026, 10, 8, 23, 59);

  test('formata no padrao que a tela le de volta', () {
    // `verificaDataAcaoDataAtual` faz parse com DateFormat('dd/MM/yyyy'):
    // qualquer outro formato quebra a comparacao que acende o selo "Hoje".
    expect(formatarDataDaAcao(quando), '08/10/2026');
  });

  test('zero a esquerda no dia e no mes', () {
    expect(formatarDataDaAcao(DateTime(2026, 1, 5)), '05/01/2026');
  });

  test('carimba a data sem descartar o que a tela ja queria gravar', () {
    final dados = comDataDaAcao(
      {'status': 'Inseminada PP', 'idStatusAnimal': 1},
      quando: quando,
    );

    expect(dados['status'], 'Inseminada PP');
    expect(dados['idStatusAnimal'], 1);
    expect(dados['dtUltimaAcao'], '08/10/2026');
  });

  test('nao muta o mapa recebido', () {
    final original = <String, dynamic>{'status': 'Vazia'};

    comDataDaAcao(original, quando: quando);

    expect(original.containsKey('dtUltimaAcao'), isFalse);
  });

  test('respeita a data que a tela informou, se ela ja carimbou', () {
    // O formulario de Acao ja gravava `dtUltimaAcao`. Ao passar pelo helper,
    // o valor dele nao pode ser sobrescrito por um carimbo automatico.
    final dados = comDataDaAcao(
      {'dtUltimaAcao': '01/01/2026'},
      quando: quando,
    );

    expect(dados['dtUltimaAcao'], '01/01/2026');
  });

  group('acaoFoiHoje', () {
    final agora = DateTime(2026, 10, 8, 14, 30);

    test('data de hoje acende o selo', () {
      expect(acaoFoiHoje('08/10/2026', agora: agora), isTrue);
    });

    test('ignora a hora: o que importa e o dia', () {
      expect(acaoFoiHoje('08/10/2026', agora: DateTime(2026, 10, 8, 0, 1)),
          isTrue);
    });

    test('data de ontem nao acende', () {
      expect(acaoFoiHoje('07/10/2026', agora: agora), isFalse);
    });

    test('vazio nao acende', () {
      expect(acaoFoiHoje('', agora: agora), isFalse);
    });

    test('nulo nao acende', () {
      expect(acaoFoiHoje(null, agora: agora), isFalse);
    });

    test('data malformada nao DERRUBA o card', () {
      // `verificaDataAcaoDataAtual` faz DateFormat.parse e lanca. As telas se
      // protegiam so com `!= ''`, o que nao cobre lixo gravado: uma data
      // invalida estourava no meio do build da lista.
      expect(acaoFoiHoje('xx/yy/zzzz', agora: agora), isFalse);
      expect(acaoFoiHoje('sem data', agora: agora), isFalse);
      expect(acaoFoiHoje('2026-10-08', agora: agora), isFalse);
    });

    test('ida e volta: o que o carimbo grava, a regra reconhece', () {
      expect(acaoFoiHoje(formatarDataDaAcao(agora), agora: agora), isTrue);
    });
  });
}
