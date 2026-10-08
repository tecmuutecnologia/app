import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/schema/structs/animais_produtores_struct.dart';
import 'package:tecmuu/features/diagnostico_gestacao/application/filtros_dg.dart';

AnimaisProdutoresStruct animal({
  String nome = 'Mimosa',
  int brinco = 7,
  String? status,
  String? grupo,
  String? inseminada,
}) =>
    AnimaisProdutoresStruct(
      nomeAnimal: nome,
      brincoAnimal: brinco,
      status: status,
      grupoAnimal: grupo,
      dtUltimaInseminacao: inseminada,
    );

List<String> nomes(List<AnimaisProdutoresStruct> l) =>
    l.map((e) => e.nomeAnimal).toList();

/// "Hoje" fixo: sem isto o teste dependeria do relogio e quebraria sozinho.
final hoje = DateTime(2026, 6, 1);

void main() {
  test('vence quando inseminacao + diasDg ja passou', () {
    // 01/01/2026 + 30 dias = 31/01/2026, anterior a 01/06/2026.
    final lista = [
      animal(
          nome: 'Vencida',
          grupo: 'Vacas',
          status: 'Inseminada',
          inseminada: '01/01/2026'),
    ];

    expect(nomes(vencidosParaDg(lista, diasDg: '30', agora: hoje)), ['Vencida']);
  });

  test('nao vence quando a data ainda esta no futuro', () {
    // 20/05/2026 + 30 dias = 19/06/2026, depois de 01/06/2026.
    final lista = [
      animal(
          nome: 'Cedo',
          grupo: 'Vacas',
          status: 'Inseminada',
          inseminada: '20/05/2026'),
    ];

    expect(vencidosParaDg(lista, diasDg: '30', agora: hoje), isEmpty);
  });

  test('aceita Inseminada PP', () {
    final lista = [
      animal(
          nome: 'PP',
          grupo: 'Novilhas',
          status: 'Inseminada PP',
          inseminada: '01/01/2026'),
    ];

    expect(nomes(vencidosParaDg(lista, diasDg: '30', agora: hoje)), ['PP']);
  });

  test('descarta status fora de inseminada', () {
    final lista = [
      animal(
          nome: 'Prenha',
          grupo: 'Vacas',
          status: 'Prenha',
          inseminada: '01/01/2026'),
    ];

    expect(vencidosParaDg(lista, diasDg: '30', agora: hoje), isEmpty);
  });

  test('descarta grupo fora de vaca/novilha', () {
    final lista = [
      animal(
          nome: 'Bezerra',
          grupo: 'Bezerras',
          status: 'Inseminada',
          inseminada: '01/01/2026'),
    ];

    expect(vencidosParaDg(lista, diasDg: '30', agora: hoje), isEmpty);
  });

  test('descarta quem nao tem data de inseminacao', () {
    final lista = [
      animal(nome: 'SemData', grupo: 'Vacas', status: 'Inseminada'),
    ];

    expect(vencidosParaDg(lista, diasDg: '30', agora: hoje), isEmpty);
  });

  group('busca', () {
    final lista = [
      animal(
          nome: 'Bonita',
          brinco: 47,
          grupo: 'Vacas',
          status: 'Inseminada',
          inseminada: '01/01/2026'),
      animal(
          nome: 'Aurora',
          brinco: 12,
          grupo: 'Vacas',
          status: 'Inseminada',
          inseminada: '01/01/2026'),
    ];

    test('vazia devolve todas', () {
      expect(vencidosParaDg(lista, diasDg: '30', agora: hoje), hasLength(2));
    });

    test('casa por nome', () {
      expect(nomes(vencidosParaDg(lista, diasDg: '30', busca: 'auro', agora: hoje)),
          ['Aurora']);
    });

    test('casa por brinco', () {
      expect(nomes(vencidosParaDg(lista, diasDg: '30', busca: '47', agora: hoje)),
          ['Bonita']);
    });
  });
}
