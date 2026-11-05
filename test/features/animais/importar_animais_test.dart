import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/data/schema/structs/animais_produtores_struct.dart';
import 'package:tecmuu/domain/animais/importacao/planilha_animais.dart';
import 'package:tecmuu/features/animais/application/importar_animais.dart';

LinhaPlanilha _valida(int n, String nome, int brinco) => LinhaPlanilha(
      numero: n,
      identificacao: '$nome $brinco',
      animal: AnimaisProdutoresStruct(nomeAnimal: nome, brincoAnimal: brinco),
    );

AnaliseImportacao _analiseComValidas(int qtd) => AnaliseImportacao(
      validas: [for (var i = 0; i < qtd; i++) _valida(i + 2, '', i + 1)],
      recusadas: const [],
    );

void main() {
  test('reimportarNaoDuplica', () {
    final a = analisarImportacao(
      [_valida(2, '', 10), _valida(3, '', 11)],
      jaExiste: (nome, brinco) => nome == '' && brinco == 10,
    );
    expect(a.validas.map((l) => l.numero), [3]);
    expect(a.recusadas.single.linha, 2);
    expect(a.recusadas.single.identificacao, ' 10');
    expect(a.recusadas.single.motivo, 'já cadastrado');
  });

  test('repetidaNaPlanilha', () {
    final a = analisarImportacao(
      [_valida(2, 'A', 1), _valida(3, 'B', 2), _valida(5, 'A', 1)],
      jaExiste: (_, __) => false,
    );
    expect(a.validas.map((l) => l.numero), [2, 3]);
    expect(a.recusadas.single.linha, 5);
    expect(a.recusadas.single.motivo, 'repetido na linha 2');
  });

  test('recusadasDaLeituraEntramOrdenadasPorLinha', () {
    final a = analisarImportacao(
      [
        _valida(2, 'A', 1),
        const LinhaPlanilha(numero: 3, identificacao: 'x', motivo: 'sem número'),
        _valida(4, 'A', 1),
      ],
      jaExiste: (_, __) => false,
    );
    expect(a.recusadas.map((r) => r.linha), [3, 4]);
    expect(a.recusadas.first.motivo, 'sem número');
  });

  test('cortaNoLimite', () async {
    final criadas = <int>[];
    final debitos = <int>[];
    final r = await gravarImportacao(
      _analiseComValidas(10),
      restante: 3,
      criar: (l) async => criadas.add(l.numero),
      debitar: debitos.add,
    );
    expect(r.importados, 3);
    expect(criadas, [2, 3, 4]);
    expect(debitos, [3]);
    expect(r.recusadas.length, 7);
    expect(r.recusadas.map((x) => x.linha), [5, 6, 7, 8, 9, 10, 11]);
    expect(r.recusadas.every((x) => x.motivo == 'limite do plano atingido'),
        isTrue);
  });

  test('semVaga', () async {
    var criou = 0;
    var debitou = 0;
    final r = await gravarImportacao(
      _analiseComValidas(4),
      restante: 0,
      criar: (_) async => criou++,
      debitar: (_) => debitou++,
    );
    expect(criou, 0);
    expect(debitou, 0);
    expect(r.importados, 0);
    expect(r.recusadas.length, 4);
  });

  test('erroAoGravarViraRecusaESegue', () async {
    final debitos = <int>[];
    final r = await gravarImportacao(
      _analiseComValidas(3),
      restante: null,
      criar: (l) async {
        if (l.numero == 3) throw Exception('boom');
      },
      debitar: debitos.add,
    );
    expect(r.importados, 2);
    expect(debitos, [2]);
    expect(r.recusadas.single.linha, 3);
    expect(r.recusadas.single.motivo, 'erro ao gravar');
  });

  test('progresso', () async {
    final vistos = <(int, int)>[];
    await gravarImportacao(
      _analiseComValidas(45),
      restante: null,
      criar: (_) async {},
      debitar: (_) {},
      aoProgredir: (f, t) => vistos.add((f, t)),
    );
    expect(vistos.last, (45, 45));
  });
}
