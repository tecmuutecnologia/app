import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/index.dart';
import 'package:tecmuu/features/animais/application/touro_inseminacao.dart';

AnimalEntity _a(String rotulo, {bool libera = true, bool apagado = false}) =>
    AnimalEntity(nomeBrincoConcat: rotulo, liberaInseminacao: libera)
      ..isDeleted = apagado;

void main() {
  test('só touros/sêmens liberados e ativos, em ordem alfabética', () {
    final opcoes = opcoesTouroInseminacao([
      _a('Esquire'),
      _a('Captain'),
      _a('Vaca 2', libera: false),
      _a('Velho', apagado: true),
      _a(''),
    ]);
    expect(opcoes, ['Captain', 'Esquire']);
  });

  test('sem repetir o mesmo rótulo', () {
    expect(opcoesTouroInseminacao([_a('Captain'), _a('Captain')]),
        ['Captain']);
  });

  test('mantém o touro já gravado mesmo que não esteja mais liberado', () {
    // Sem isto o campo do editar abria vazio e salvar apagava o vínculo.
    expect(opcoesTouroInseminacao([_a('Esquire')], atual: 'Antigo'),
        ['Antigo', 'Esquire']);
  });
}
