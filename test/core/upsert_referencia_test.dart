import 'package:flutter_test/flutter_test.dart';
import 'package:tecmuu/core/sync/upsert_referencia.dart';

/// Stand-in para as entidades de referência (grupo, raça, status...): todas têm
/// um `id` local do ObjectBox e um `firestoreId` marcado como `@Unique`.
class _Ref {
  _Ref({this.id = 0, this.firestoreId});
  int id;
  String? firestoreId;
}

/// `fromFirestore` sempre devolve `id = 0`, o que faz o ObjectBox INSERIR.
/// No segundo download completo do aparelho — troca de usuário, ou o
/// re-download automático quando o cache de animais está vazio — isso violava
/// o índice único e derrubava o download inteiro logo no primeiro passo:
///
///   Unique constraint for GrupoEntity.firestoreId would be violated
///
/// Como o erro sobe, nem propriedades nem animais chegavam a ser baixados.
void main() {
  group('reaproveitarIds', () {
    test('baixado que já existe herda o id local, virando UPDATE', () {
      final baixados = [_Ref(firestoreId: 'grupo-vacas')];

      reaproveitarIds(
        existentes: [_Ref(id: 1, firestoreId: 'grupo-vacas')],
        baixados: baixados,
        firestoreIdDe: (e) => e.firestoreId,
        idDe: (e) => e.id,
        definirId: (e, id) => e.id = id,
      );

      expect(baixados.single.id, 1);
    });

    test('baixado inédito continua com id 0, virando INSERT', () {
      final baixados = [_Ref(firestoreId: 'grupo-novo')];

      reaproveitarIds(
        existentes: [_Ref(id: 1, firestoreId: 'grupo-vacas')],
        baixados: baixados,
        firestoreIdDe: (e) => e.firestoreId,
        idDe: (e) => e.id,
        definirId: (e, id) => e.id = id,
      );

      expect(baixados.single.id, 0);
    });

    test('cada baixado casa com o seu, não com o primeiro', () {
      final baixados = [
        _Ref(firestoreId: 'b'),
        _Ref(firestoreId: 'a'),
        _Ref(firestoreId: 'c'),
      ];

      reaproveitarIds(
        existentes: [
          _Ref(id: 10, firestoreId: 'a'),
          _Ref(id: 20, firestoreId: 'b'),
        ],
        baixados: baixados,
        firestoreIdDe: (e) => e.firestoreId,
        idDe: (e) => e.id,
        definirId: (e, id) => e.id = id,
      );

      expect(baixados.map((e) => e.id), [20, 10, 0]);
    });

    test('firestoreId nulo não casa com nada nem quebra', () {
      final baixados = [_Ref(firestoreId: null)];

      reaproveitarIds(
        existentes: [_Ref(id: 1, firestoreId: null)],
        baixados: baixados,
        firestoreIdDe: (e) => e.firestoreId,
        idDe: (e) => e.id,
        definirId: (e, id) => e.id = id,
      );

      expect(baixados.single.id, 0);
    });

    test('banco local vazio: tudo continua sendo INSERT', () {
      final baixados = [_Ref(firestoreId: 'a'), _Ref(firestoreId: 'b')];

      reaproveitarIds(
        existentes: const <_Ref>[],
        baixados: baixados,
        firestoreIdDe: (e) => e.firestoreId,
        idDe: (e) => e.id,
        definirId: (e, id) => e.id = id,
      );

      expect(baixados.map((e) => e.id), [0, 0]);
    });
  });
}
