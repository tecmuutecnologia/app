import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/schema/structs/animais_produtores_struct.dart';
import 'package:tecmuu/domain/animais/regras_cadastro_animal.dart';

final _hoje = DateTime(2026, 11, 4);

EntradaCadastroAnimal _entrada({
  String nome = 'Mimosa',
  String brinco = '12',
  String grupo = 'Vacas',
  String? status,
  String inseminacao = '',
  String parto = '',
  bool? libera,
}) =>
    EntradaCadastroAnimal(
      nome: nome,
      brinco: brinco,
      raca: 'Holandesa',
      grupo: grupo,
      peso: '400',
      dtNascimento: '01/01/2020',
      touro: 'Pai',
      vaca: 'Mae',
      status: status,
      dtUltimaInseminacao: inseminacao,
      dtUltimoParto: parto,
      touroInseminacao: 'Touro X',
      liberaInseminacao: libera,
      hoje: _hoje,
    );

AnimaisProdutoresStruct _ok(EntradaCadastroAnimal e) {
  final r = montarAnimal(e);
  expect(r, isA<CadastroValido>());
  return (r as CadastroValido).animal;
}

void _recusa(EntradaCadastroAnimal e, String titulo, String msg) {
  final r = montarAnimal(e);
  expect(r, isA<CadastroRecusado>());
  expect((r as CadastroRecusado).titulo, titulo);
  expect(r.mensagem, msg);
}

const _semInsem =
    'Data última inseminação vazia ou Touro inseminação não selecionado.';
const _preencha = 'Preencha os campos obrigatórios.';

void main() {
  test('nome e brinco vazios recusa', () {
    _recusa(_entrada(nome: '', brinco: '', status: 'Vazia'),
        'Nome ou brinco obrigatório.', 'Preencha ao menos um dos campos.');
  });

  test('Vaca sem status recusa', () {
    _recusa(_entrada(), 'Status é obrigatório.',
        'Selecione ao menos um status.');
  });

  test('Inseminada sem parto', () {
    final a = _ok(_entrada(status: 'Inseminada', inseminacao: '01/01/2026'));
    expect(a.idStatusAnimal, 3);
    expect(a.status, 'Inseminada');
    expect(a.dtPartoPrevisto, '08/10/2026');
    expect(a.dtSecPrevista, '09/08/2026');
    expect(a.dtPrePartoPrevista, '17/09/2026');
    expect(a.totalInseminacoes, 1);
    expect(a.totalPartos, 0);
    expect(a.nomeTouroUltimaInseminacao, 'Touro X');
    expect(a.compararDtUltimaInseminacao, DateTime(2026, 1, 1));
    expect(a.brincoAnimal, 12);
    expect(a.nomeBrincoConcat, 'Mimosa - 12');
    expect(a.vaca, 'Mae');
  });

  test('Inseminada com parto', () {
    final a = _ok(_entrada(
        status: 'Inseminada', inseminacao: '01/01/2026', parto: '01/06/2025'));
    expect(a.idStatusAnimal, 3);
    expect(a.totalInseminacoes, 1);
    expect(a.totalPartos, 1);
    expect(a.dtUltimoParto, '01/06/2025');
    expect(a.dtUltimoPartoContingencia, '01/06/2025');
    expect(a.dtPartoPrevisto, '08/10/2026');
  });

  test('Inseminada sem inseminação recusa', () {
    _recusa(_entrada(status: 'Inseminada'), _semInsem, _preencha);
    _recusa(_entrada(status: 'Inseminada', parto: '01/06/2025'), _semInsem,
        _preencha);
  });

  test('Seca em Vacas', () {
    final a = _ok(_entrada(status: 'Seca', inseminacao: '01/01/2026'));
    expect(a.idStatusAnimal, 4);
    expect(a.status, 'Seca');
    expect(a.dtSecPrevista, '09/08/2026');
    expect(a.totalInseminacoes, 0);
  });

  test('Seca em Novilhas recusa', () {
    _recusa(_entrada(grupo: 'Novilhas', status: 'Seca'),
        'O status de "Seca" é permitido somente em vacas.',
        'Atualize o status.');
  });

  test('Vazia sem e com parto', () {
    final a = _ok(_entrada(status: 'Vazia'));
    expect(a.idStatusAnimal, 2);
    expect(a.totalPartos, 0);
    expect(a.totalInseminacoes, 0);
    final b = _ok(_entrada(status: 'Vazia', parto: '01/06/2025'));
    expect(b.totalPartos, 1);
    expect(b.dtUltimoParto, '01/06/2025');
    expect(b.dtUltimoPartoContingencia, '01/06/2025');
  });

  test('Prenha', () {
    final a = _ok(_entrada(
        status: 'Prenha', inseminacao: '01/01/2026', parto: '01/06/2025'));
    expect(a.idStatusAnimal, 6);
    expect(a.dtDgMais, '04/11/2026');
    expect(a.dtPP, '');
    expect(a.totalInseminacoes, 1);
    expect(a.dtPrePartoPrevista, '17/09/2026');
    expect(a.dtUltimoPartoContingencia, '01/06/2025');
    _recusa(_entrada(status: 'Prenha'), _semInsem, _preencha);
  });

  test('Inseminada PP', () {
    final a = _ok(_entrada(
        grupo: 'Novilhas', status: 'Inseminada PP', inseminacao: '01/01/2026'));
    expect(a.idStatusAnimal, 1);
    expect(a.dtPP, '04/11/2026');
    expect(a.dtUltimoPP, '04/11/2026');
    expect(a.dtDgMais, '');
    expect(a.totalInseminacoes, 1);
    _recusa(_entrada(status: 'Inseminada PP'), _semInsem, _preencha);
  });

  test('Pré Parto', () {
    final a = _ok(_entrada(status: 'Pré Parto', inseminacao: '01/01/2026'));
    expect(a.idStatusAnimal, 5);
    expect(a.dtPP, '04/11/2026');
    expect(a.dtUltimoPP, '04/11/2026');
    expect(a.dtPartoPrevisto, '08/10/2026');
    _recusa(_entrada(status: 'Pré Parto'), _semInsem, _preencha);
  });

  test('status desconhecido recusa', () {
    _recusa(_entrada(status: 'Xyz'), 'Status inválido.',
        'Selecione um status válido.');
  });

  test('Touros grava liberaInseminacao e vaca', () {
    final a = _ok(_entrada(grupo: 'Touros', libera: false));
    expect(a.liberaInseminacao, false);
    expect(a.vaca, 'Mae');
    expect(a.idStatusAnimal, 0);
  });

  test('Sêmens grava liberaInseminacao e não grava vaca', () {
    final a = _ok(_entrada(grupo: 'Sêmens', libera: true));
    expect(a.liberaInseminacao, true);
    expect(a.vaca, '');
    expect(a.touro, 'Pai');
  });

  test('outros grupos só com campos comuns', () {
    final a = _ok(_entrada(grupo: 'Bezerras', status: 'Vazia'));
    expect(a.grupoAnimal, 'Bezerras');
    expect(a.status, '');
    expect(a.idStatusAnimal, 0);
    expect(a.vaca, 'Mae');
    expect(a.pesoAnimal, '400');
  });

  test('sem brinco: -1, 999999 e concat só com nome', () {
    final a = _ok(_entrada(brinco: '', grupo: 'Bezerras'));
    expect(a.brincoAnimal, -1);
    expect(a.brincoAnimalOrder, 999999);
    expect(a.nomeBrincoConcat, 'Mimosa');
  });

  test('sem nome, concat é o brinco; brinco -1 ignora o brinco', () {
    expect(_ok(_entrada(nome: '', grupo: 'Bezerras')).nomeBrincoConcat, '12');
    expect(_ok(_entrada(brinco: '-1', grupo: 'Bezerras')).nomeBrincoConcat,
        'Mimosa');
  });
}
