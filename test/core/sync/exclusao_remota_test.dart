import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/exclusao_remota.dart';

void main() {
  test('reconhece só o marcador próprio', () {
    expect(ehExclusaoRemota({'excluido': true}), isTrue);
    // isDeleted sozinho é a lixeira da propriedade, não exclusão definitiva.
    expect(ehExclusaoRemota({'isDeleted': true}), isFalse);
    expect(ehExclusaoRemota({'excluido': false}), isFalse);
    expect(ehExclusaoRemota(null), isFalse);
  });

  test('payload carrega marcador, isDeleted e lastModified', () {
    final p = payloadDeExclusao();
    expect(p['excluido'], isTrue);
    expect(p['isDeleted'], isTrue);
    expect(p.containsKey('lastModified'), isTrue);
  });

  test('separa excluídos dos vivos', () {
    final docs = [
      ('a', <String, dynamic>{'nome': 'Mimosa'}),
      ('b', <String, dynamic>{'excluido': true}),
      ('c', <String, dynamic>{'isDeleted': true}),
    ];
    final r = separarExclusoes(docs, idDe: (d) => d.$1, dadosDe: (d) => d.$2);
    expect(r.vivos.map((d) => d.$1), ['a', 'c']);
    expect(r.excluidos, {'b'});
  });
}
