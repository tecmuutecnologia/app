import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/objectbox/entities/reference_entities.dart';
import 'package:tecmuu/domain/animais/importacao/planilha_animais.dart';

const _cab = [
  'Nome (opcional)', 'Número*', 'Raça*', 'Categoria*',
  'Data de Nascimento(opcional)', 'Pai (opcional)', 'Mãe (opcional)',
  'Parto (opcional)', 'Inseminação (opcional)', 'Status*',
];
final _racas = ['Holandesa', 'Jersey', 'Gir', 'Brahman', 'Brahvieh'];
final _grupos = ['Vacas', 'Novilhas', 'Touros', 'Semêns'];
final _status = [
  for (final s in ['Inseminada', 'Inseminada PP', 'Prenha', 'Seca', 'Pré Parto', 'Vazia'])
    StatusAnimalEntity(descricao: s)
];
final _hoje = DateTime(2026, 11, 4);

List<LinhaPlanilha> _ler(List<List<Object?>> corpo) => lerLinhas([_cab, ...corpo],
    racas: _racas, grupos: _grupos, status: _status, hoje: _hoje);

void main() {
  test('cabecalhoDoModeloPassa', () {
    expect(erroDeCabecalho(_cab), isNull);
    final t = [..._cab];
    t[3] = 'Status*';
    t[9] = 'Categoria*';
    expect(erroDeCabecalho(t), 'A coluna D deveria ser Categoria e está Status.');
    expect(erroDeCabecalho(_cab.sublist(0, 3)),
        'A coluna D deveria ser Categoria e está vazia.');
  });

  test('lerData', () {
    expect(lerData('2021-11-20T00:00:00.000'), '20/11/2021');
    expect(lerData(44520), '20/11/2021');
    expect(lerData('20/11/21'), '20/11/2021');
    expect(lerData('20-11-2021'), '20/11/2021');
    expect(lerData(null), isNull);
    expect(() => lerData('31/02/2021'), throwsFormatException);
  });

  test('linhaDoModelo', () {
    final r = _ler([
      [null, 10, 'Ho', 'Vaca', '2021-11-20T00:00:00.000', null, null,
        '2026-07-03T00:00:00.000', '2026-09-15T00:00:00.000', 'InseminadaPP']
    ]).single;
    expect(r.motivo, isNull);
    expect(r.numero, 2);
    expect(r.entrada!.raca, 'Holandesa');
    expect(r.entrada!.grupo, 'Vacas');
    expect(r.entrada!.status, 'Inseminada PP');
    expect(r.entrada!.brinco, '10');
    expect(r.animal, isNotNull);
    expect(r.animal!.brincoAnimal, 10);
  });

  test('ignoraLinhasVazias', () {
    final v = List<Object?>.filled(10, null);
    expect(_ler([v, v, v]), isEmpty);
    expect(_ler([[null, 1, 'Ho', 'Touro'], v]).length, 1);
  });

  test('touro e sêmen ignoram status e liberam inseminação', () {
    final r = _ler([
      [null, 1, 'Ho', 'Touro', null, null, null, null, null, 'Xyz'],
      ['S', null, 'Je', 'Semen'],
    ]);
    expect(r.every((e) => e.motivo == null), isTrue);
    expect(r[0].animal!.liberaInseminacao, isTrue);
    expect(r[1].entrada!.grupo, 'Semêns');
  });

  void recusa(List<Object?> linha, String motivo) {
    final r = _ler([linha]).single;
    expect(r.motivo, motivo);
    expect(r.animal, isNull);
  }

  test('recusas', () {
    recusa([null, '10a', 'Ho', 'Vaca'], 'número inválido: 10a');
    recusa([null, 1, 'Xyz', 'Vaca'], 'raça não reconhecida: Xyz');
    recusa([null, 1, 'Br', 'Vaca'], 'raça não reconhecida: Br');
    recusa([null, 1, 'Ho', 'Boi'], 'categoria não reconhecida: Boi');
    recusa([null, 1, 'Ho', 'Vaca', null, null, null, '01/01/2027', null, 'Vazia'],
        'data no futuro na coluna H: 01/01/2027');
    recusa([null, 1, 'Ho', 'Vaca', 'abc', null, null, null, null, 'Vazia'],
        'data inválida na coluna E: abc');
    recusa([null, 1, 'Ho', 'Vaca', null, null, null, null, '01/01/2026', 'Vazia'],
        'status Vazia não combina com as datas de parto e inseminação');
    recusa([null, 1, 'Ho', 'Novilha', null, null, null, null, '01/01/2026', 'Seca'],
        'status Seca não combina com as datas de parto e inseminação');
    recusa([null, 1, 'Ho', 'Vaca', null, null, null, null, null, 'Foo'],
        'status não reconhecido: Foo');
    recusa([null, null, 'Ho', 'Vaca', null, null, null, null, null, 'Vazia'],
        'Nome ou brinco obrigatório.');
    recusa([null, 1, 'Ho', 'Vaca'], 'Status é obrigatório.');
  });

  test('prefixo único de raça', () {
    expect(_ler([[null, 1, 'Brahm', 'Touro']]).single.entrada!.raca, 'Brahman');
  });

  test('número: negativo e mais de 9 dígitos são recusados; zero passa', () {
    recusa([null, -1, 'Ho', 'Touro'], 'número inválido: -1');
    recusa([null, -5, 'Ho', 'Touro'], 'número inválido: -5');
    recusa([null, '-3', 'Ho', 'Touro'], 'número inválido: -3');
    recusa([null, '1234567890', 'Ho', 'Touro'], 'número inválido: 1234567890');
    recusa([null, 1234567890, 'Ho', 'Touro'], 'número inválido: 1234567890');
    expect(_ler([[null, 0, 'Ho', 'Touro']]).single.motivo, isNull);
    expect(_ler([[null, '123456789', 'Ho', 'Touro']]).single.motivo, isNull);
  });

  test('ano com 2 dígitos usa pivô no ano corrente', () {
    expect(lerData('20/11/99', hoje: _hoje), '20/11/1999');
    expect(lerData('20/11/21', hoje: _hoje), '20/11/2021');
    expect(lerData('20/11/26', hoje: _hoje), '20/11/2026');
    expect(lerData('20/11/27', hoje: _hoje), '20/11/1927');
    final r = _ler([[null, 1, 'Ho', 'Touro', '20/11/99']]).single;
    expect(r.entrada!.dtNascimento, '20/11/1999');
  });

  test('raça só com pontuação não casa por prefixo', () {
    final r = lerLinhas([
      _cab,
      [null, 1, '*', 'Touro'],
    ], racas: ['Holandesa'], grupos: _grupos, status: _status, hoje: _hoje)
        .single;
    expect(r.motivo, 'raça não reconhecida: *');
  });

  test('hífen é ignorado na comparação (Pré-parto)', () {
    expect(normalizar('Pré-parto'), 'preparto');
    final r = _ler([
      [null, 1, 'Ho', 'Vaca', null, null, null, '2026-07-03T00:00:00.000',
        '2026-09-15T00:00:00.000', 'Pré-parto']
    ]).single;
    expect(r.entrada?.status, 'Pré Parto');
    expect(erroDeCabecalho(_cab), isNull);
  });
}
